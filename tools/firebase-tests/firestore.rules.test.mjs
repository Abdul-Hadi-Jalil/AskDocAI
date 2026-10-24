import { readFile } from 'node:fs/promises';
import { after, before, beforeEach, test } from 'node:test';
import { strict as assert } from 'node:assert';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { initializeApp, deleteApp } from 'firebase/app';
import { connectAuthEmulator, createUserWithEmailAndPassword, getAuth, sendPasswordResetEmail, signInWithEmailAndPassword, signOut } from 'firebase/auth';
import { collection, deleteDoc, doc, getDoc, getDocs, limit, orderBy, query, serverTimestamp, setDoc, Timestamp, updateDoc, writeBatch } from 'firebase/firestore';

let env;
before(async () => {
  env = await initializeTestEnvironment({ projectId: 'demo-askdocai', firestore: {
    host: '127.0.0.1', port: 8080,
    rules: await readFile(new URL('../../firestore.rules', import.meta.url), 'utf8'),
  }});
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());

const chatPath = 'users/alice/chats/document-a';
const exchangePath = `${chatPath}/exchanges/turn-a`;
const chat = (overrides = {}) => ({ ownerId: 'alice', documentName: 'sample.pdf', createdAt: serverTimestamp(), updatedAt: serverTimestamp(), ...overrides });
const exchange = (overrides = {}) => ({ ownerId: 'alice', question: 'What does this mean?', answer: 'An explanation.', createdAt: serverTimestamp(), ...overrides });
const alice = () => env.authenticatedContext('alice').firestore();
async function seed() {
  const db = alice();
  const batch = writeBatch(db);
  batch.set(doc(db, chatPath), chat());
  batch.set(doc(db, exchangePath), exchange());
  await assertSucceeds(batch.commit());
  return db;
}

test('owner creates parent and exchange atomically, reads and performs app history query', async () => {
  const db = await seed();
  await assertSucceeds(getDoc(doc(db, chatPath)));
  const result = await assertSucceeds(getDocs(query(collection(db, `${chatPath}/exchanges`), orderBy('createdAt', 'desc'), limit(100))));
  assert.equal(result.size, 1);
  await assertSucceeds(updateDoc(doc(db, chatPath), { updatedAt: serverTimestamp() }));
});

test('anonymous and other accounts cannot read, list, create, update or delete private data', async () => {
  await seed();
  for (const context of [env.unauthenticatedContext(), env.authenticatedContext('bob')]) {
    const db = context.firestore();
    await assertFails(getDoc(doc(db, chatPath)));
    await assertFails(getDocs(collection(db, `${chatPath}/exchanges`)));
    await assertFails(setDoc(doc(db, 'users/alice/chats/stolen'), chat()));
    await assertFails(updateDoc(doc(db, chatPath), { updatedAt: serverTimestamp() }));
    await assertFails(setDoc(doc(db, `${chatPath}/exchanges/attack`), exchange()));
    await assertFails(deleteDoc(doc(db, exchangePath)));
  }
});

test('ownership hijacking, schema pollution, missing fields and type juggling are rejected', async () => {
  const db = alice();
  for (const data of [chat({ownerId: 'bob'}), chat({isAdmin: true}), chat({documentName: 123}), chat({documentName: 'x'.repeat(513)})]) {
    await assertFails(setDoc(doc(db, chatPath), data));
  }
  const missing = chat(); delete missing.documentName;
  await assertFails(setDoc(doc(db, chatPath), missing));
  await seed();
  for (const data of [{ownerId: 'bob'}, {documentName: 'changed.pdf'}, {isAdmin: true}, {createdAt: Timestamp.fromMillis(0)}, {documentName: 'x'.repeat(1000000)}]) {
    await assertFails(updateDoc(doc(db, chatPath), {...data, updatedAt: serverTimestamp()}));
  }
  await assertFails(setDoc(doc(db, 'users/alice'), {isAdmin: true}));
});

test('exchanges require an existing or atomic parent, exact schema and bounded strings', async () => {
  const db = alice();
  await assertFails(setDoc(doc(db, exchangePath), exchange()));
  await seed();
  for (const data of [exchange({ownerId: 'bob'}), exchange({question: ''}), exchange({answer: 'x'.repeat(24001)}), exchange({question: 10}), exchange({createdAt: Timestamp.fromMillis(0)}), exchange({role: 'admin'})]) {
    await assertFails(setDoc(doc(db, `${chatPath}/exchanges/invalid`), data));
  }
  const missing = exchange(); delete missing.answer;
  await assertFails(setDoc(doc(db, `${chatPath}/exchanges/missing`), missing));
  await assertFails(updateDoc(doc(db, exchangePath), {answer: 'Changed'}));
  await assertFails(deleteDoc(doc(db, exchangePath)));
  await assertFails(deleteDoc(doc(db, chatPath)));
});

test('email/password creates an account, signs out, signs in and requests password reset', async () => {
  const app = initializeApp({projectId: 'demo-askdocai', apiKey: 'emulator-only-key'}, 'email-auth-test');
  try {
    const auth = getAuth(app);
    connectAuthEmulator(auth, 'http://127.0.0.1:9099', {disableWarnings: true});
    const email = `authentication-${Date.now()}@askdocai.test`;
    const created = await createUserWithEmailAndPassword(auth, email, 'Test-password-123');
    const uid = created.user.uid;
    await signOut(auth);
    assert.equal(auth.currentUser, null);
    const signedIn = await signInWithEmailAndPassword(auth, email, 'Test-password-123');
    assert.equal(signedIn.user.uid, uid);
    await sendPasswordResetEmail(auth, email);
    await signOut(auth);
  } finally { await deleteApp(app); }
});

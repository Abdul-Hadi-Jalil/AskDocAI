import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

class SavedChatExchange {
  const SavedChatExchange({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;
}

abstract interface class ChatStore {
  Future<List<SavedChatExchange>> load();
  Future<void> save(SavedChatExchange exchange);
}

/// Private document conversations. Source document contents stay on the device.
class FirestoreChatStore implements ChatStore {
  FirestoreChatStore({
    required this.userId,
    required String documentName,
    required String documentContent,
  }) : documentName = documentName.length > 512
           ? documentName.substring(0, 512)
           : documentName,
       conversationId = documentId(documentName, documentContent);

  static const databaseId = 'askdocai';
  static String documentId(String name, String content) =>
      const Uuid().v5(Namespace.url.value, '$name\u0000$content');

  final String userId;
  final String documentName;
  final String conversationId;

  FirebaseFirestore get _db => FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: databaseId,
  );
  DocumentReference<Map<String, dynamic>> get _conversation => _db
      .collection('users')
      .doc(userId)
      .collection('chats')
      .doc(conversationId);

  void _checkUser() {
    if (FirebaseAuth.instance.currentUser?.uid != userId) {
      throw StateError('The chat belongs to a different sign-in session.');
    }
  }

  @override
  Future<List<SavedChatExchange>> load() async {
    _checkUser();
    if (!(await _conversation.get()).exists) return [];
    final snapshot = await _conversation
        .collection('exchanges')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();
    _checkUser();
    return snapshot.docs.reversed.map((doc) {
      final data = doc.data();
      return SavedChatExchange(
        id: doc.id,
        question: data['question'] as String,
        answer: data['answer'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> save(SavedChatExchange exchange) async {
    _checkUser();
    if (exchange.question.isEmpty ||
        exchange.question.length > 24000 ||
        exchange.answer.isEmpty ||
        exchange.answer.length > 24000) {
      throw ArgumentError('Chat messages must contain 1–24000 characters.');
    }
    final conversation = _conversation;
    final entry = conversation.collection('exchanges').doc(exchange.id);
    await _db.runTransaction((transaction) async {
      _checkUser();
      final parent = await transaction.get(conversation);
      final existing = parent.exists ? await transaction.get(entry) : null;
      // A retry must not create duplicate messages or change their timestamps.
      if (existing?.exists ?? false) return;
      final now = FieldValue.serverTimestamp();
      if (parent.exists) {
        transaction.update(conversation, {'updatedAt': now});
      } else {
        transaction.set(conversation, {
          'ownerId': userId,
          'documentName': documentName,
          'createdAt': now,
          'updatedAt': now,
        });
      }
      transaction.set(entry, {
        'ownerId': userId,
        'question': exchange.question,
        'answer': exchange.answer,
        'createdAt': now,
      });
    });
  }
}

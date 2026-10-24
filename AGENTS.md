# Firebase work

- Always discover and read the appropriate Firebase agent skills before doing
  Firebase-related work. Project skills are in `.agents/skills/`.
- Follow `firebase-basics` for CLI login/project selection/config downloads,
  `firebase-auth-basics` for authentication, and `firebase-firestore` plus the
  applicable rules skill for Firestore data and security rules.
- Use Firebase MCP tools for remote Firebase operations when required by those
  skills, and verify that the server is connected before proceeding.
- The user's selected existing Firebase project is `askdocai-b699d`. Do not use
  the old `vault-99bd4` configuration as the target for new setup work.
- The intended backend is Firebase Authentication with email/password and
  Cloud Firestore for the chatbot app.
- Keep the Dart package `askdocai` and native identifier
  `com.example.askdocai`. Preserve retained platforms; iOS support was removed.
- Preserve existing user changes and do not stage, commit, or push automatically.

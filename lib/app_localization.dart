import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Your AI-Powered Document Assistant',
      'loadingApplication': 'Loading application',
      'pleaseUploadPdfFirst': 'Please upload a PDF first to start chatting',
      'home': 'Home',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Summary',
      'signIn': 'Sign In',
      'signOut': 'Sign Out',
      'uploadFile': 'Upload File',
      'startQuiz': 'Start Quiz',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit',
      'loading': 'Loading...',
      'error': 'An error occurred',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Select Language',
      'chatWithAny': 'Chat with any ',
      'document': 'Document',
      'uploadAndChatDescription':
          'Upload a PDF and start chatting with your document',
      'uploadPdfHere': 'Upload PDF here',
      'tapToSelectFile': 'Tap to select a file',
      'uploadPdf': 'Upload PDF',
      'chatWelcomeMessage':
          'Hello! I\'m ready to help you understand "%fileName". What would you like to know?',
      'errorTryAgain': 'Sorry, I encountered an error. Please try again.',
      'fileTypePdf': 'Type: PDF Document',
      'uploadedJustNow': 'Uploaded: Just now',
      'fileSize': 'Size: %fileSize',
      'fileName': 'Name: %fileName',
      'ok': 'OK',
      'noFileSelected': 'No file selected',
      'fileInformation': 'File Information',
      'name': 'Name',
      'noFile': 'No file',
      'size': 'Size',
      'generatingQuiz': 'Generating quiz from your document...',
      'documentQuiz': 'Document Quiz',
      'generateQuizDescription':
          'Generate a quiz based on your uploaded document',
      'testUnderstanding': 'Test your understanding of the document',
      'generateQuizFromDocument': 'Generate Quiz',
      'regenerateQuiz': 'Regenerate Quiz',
      'checkAnswers': 'Check Answers',
      'uploadPdfFirstForQuiz': 'Please upload a PDF first to generate a quiz',
      'failedToGenerateQuiz': 'Failed to generate quiz',
      'noValidQuizQuestions': 'No valid quiz questions were generated',
      'answerAllQuestions':
          'Please answer all %total questions. You have answered %answered.',
      'analyzingDocument': 'Analyzing document and generating summary...',
      'mayTakeFewMoments': 'This may take a few moments',
      'failedToGenerateSummary': 'Failed to generate summary',
      'tryAgain': 'Try Again',
      'generateSummary': 'Generate Summary',
      'noDocumentUploaded': 'No Document Uploaded',
      'tapToGenerateSummary':
          'Tap below to analyze your document and generate a comprehensive summary',
      'uploadFirstForSummary':
          'Upload a document first to generate an AI-powered summary',
      'uploadDocument': 'Upload Document',
      'Document': 'Document',
      'documentSummary': 'Document Summary',
      'aiGeneratedInsights': 'AI-generated insights from',
      'executiveSummary': 'Executive Summary',
      'conclusionsRecommendations': 'Conclusions & Recommendations',
      'keyFindings': 'Key Findings',
      'mainTopics': 'Main Topics',
      'regenerate': 'Regenerate',
      'shareSummary': 'Share Summary',
      'shareFunctionality': 'Share functionality would open here',
      'whatYouCanDo': 'What You Can Do',
      'chatDescription':
          'Chat with your document and ask questions about its content',
      'summaryDescription':
          'Get a concise summary of the key points in your document',
      'quizDescription':
          'Test your knowledge with questions based on your document',
      'recentFiles': 'Recent Files',
      'signInToUpload': 'Sign in to upload documents',
      'signInDescription':
          'Please sign in with your Google or Apple account to continue with document uploads.',
      'signInWithGoogle': 'Sign in with Google',
      'signInWithApple': 'Sign in with Apple',
      'signingInWithGoogle': 'Signing in with Google...',
      'signingInWithApple': 'Signing in with Apple...',
      'googleSignInSuccess': 'Signed in with Google successfully!',
      'appleSignInSuccess': 'Signed in with Apple successfully!',
      'googleSignInFailed': 'Google sign-in failed. Please try again.',
      'appleSignInFailed': 'Apple sign-in failed. Please try again.',
      'googleSignInError': 'Error during Google sign-in:',
      'appleSignInError': 'Error during Apple sign-in:',
      'cancel': 'Cancel',
      'english': 'English',
      'spanish': 'Spanish',
      'french': 'French',
      'german': 'German',
      'dutch': 'Dutch',
      'arabic': 'Arabic',
      'chinese': 'Chinese',
      'confirmSignOut': 'Are you sure you want to sign out?',
      'confirm': 'Confirm',
      'signedInSuccessfully': 'Signed in successfully',
    },
    'es': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Tu Asistente de Documentos con IA',
      'loadingApplication': 'Cargando aplicación',
      'pleaseUploadPdfFirst': 'Por favor, sube un PDF primero para chatear',
      'home': 'Inicio',
      'chat': 'Chat',
      'quiz': 'Cuestionario',
      'summary': 'Resumen',
      'signIn': 'Iniciar Sesión',
      'signOut': 'Cerrar Sesión',
      'uploadFile': 'Subir Archivo',
      'startQuiz': 'Comenzar Quiz',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'submit': 'Enviar',
      'loading': 'Cargando...',
      'error': 'Ocurrió un error',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Seleccionar idioma',
      'chatWithAny': 'Chatea con cualquier ',
      'document': 'Documento',
      'uploadAndChatDescription':
          'Sube un PDF y comienza a chatear con tu documento',
      'uploadPdfHere': 'Subir PDF aquí',
      'tapToSelectFile': 'Toca para seleccionar un archivo',
      'uploadPdf': 'Subir PDF',
      'chatWelcomeMessage':
          '¡Hola! Estoy listo para ayudarte a entender "%fileName". ¿Qué te gustaría saber?',
      'errorTryAgain':
          'Lo siento, encontré un error. Por favor, inténtalo de nuevo.',
      'fileTypePdf': 'Tipo: Documento PDF',
      'uploadedJustNow': 'Subido: Hace un momento',
      'fileSize': 'Tamaño: %fileSize',
      'fileName': 'Nombre: %fileName',
      'ok': 'Aceptar',
      'noFileSelected': 'No se seleccionó archivo',
      'fileInformation': 'Información del Archivo',
      'name': 'Nombre',
      'noFile': 'Sin archivo',
      'size': 'Tamaño',
      'analyzingDocument': 'Analizando documento y generando resumen...',
      'mayTakeFewMoments': 'Esto puede tomar unos momentos',
      'failedToGenerateSummary': 'Error al generar el resumen',
      'tryAgain': 'Intentar de nuevo',
      'generateSummary': 'Generar Resumen',
      'noDocumentUploaded': 'Ningún Documento Subido',
      'tapToGenerateSummary':
          'Toca abajo para analizar tu documento y generar un resumen completo',
      'uploadFirstForSummary':
          'Sube un documento primero para generar un resumen con IA',
      'uploadDocument': 'Subir Documento',
      'Document': 'Documento',
      'documentSummary': 'Resumen del Documento',
      'aiGeneratedInsights': 'Información generada por IA de',
      'executiveSummary': 'Resumen Ejecutivo',
      'conclusionsRecommendations': 'Conclusiones y Recomendaciones',
      'keyFindings': 'Hallazgos Clave',
      'mainTopics': 'Temas Principales',
      'regenerate': 'Regenerar',
      'shareSummary': 'Compartir Resumen',
      'shareFunctionality': 'La funcionalidad de compartir se abriría aquí',
      'generatingQuiz': 'Generando cuestionario desde tu documento...',
      'documentQuiz': 'Cuestionario del Documento',
      'generateQuizDescription':
          'Genera un cuestionario basado en tu documento subido',
      'testUnderstanding': 'Pon a prueba tu comprensión del documento',
      'generateQuizFromDocument': 'Generar Cuestionario',
      'regenerateQuiz': 'Regenerar Cuestionario',
      'checkAnswers': 'Verificar Respuestas',
      'uploadPdfFirstForQuiz':
          'Por favor, sube un PDF primero para generar un cuestionario',
      'failedToGenerateQuiz': 'Error al generar el cuestionario',
      'noValidQuizQuestions':
          'No se generaron preguntas válidas para el cuestionario',
      'answerAllQuestions':
          'Por favor responde todas las %total preguntas. Has respondido %answered.',

      // New strings for features section
      'whatYouCanDo': 'Lo que puedes hacer',
      'chatDescription':
          'Habla con tu documento y haz preguntas sobre su contenido',
      'summaryDescription':
          'Obtén un resumen conciso de los puntos clave del documento',
      'recentFiles': 'Archivos Recientes',
      'quizDescription':
          'Pon a prueba tu conocimiento con preguntas basadas en el documento',
      'signInToUpload': 'Inicia sesión para subir documentos',
      'signInDescription':
          'Por favor, inicia sesión con tu cuenta de Google o Apple para continuar con la subida de documentos.',
      'signInWithGoogle': 'Iniciar sesión con Google',
      'signInWithApple': 'Iniciar sesión con Apple',
      'signingInWithGoogle': 'Iniciando sesión con Google...',
      'signingInWithApple': 'Iniciando sesión con Apple...',
      'googleSignInSuccess': '¡Sesión iniciada con Google exitosamente!',
      'appleSignInSuccess': '¡Sesión iniciada con Apple exitosamente!',
      'googleSignInFailed':
          'Error al iniciar sesión con Google. Por favor, inténtalo de nuevo.',
      'appleSignInFailed':
          'Error al iniciar sesión con Apple. Por favor, inténtalo de nuevo.',
      'googleSignInError': 'Error durante el inicio de sesión con Google:',
      'appleSignInError': 'Error durante el inicio de sesión con Apple:',
      'cancel': 'Cancelar',
      'confirmSignOut': '¿Estás seguro de que quieres cerrar sesión?',
      'confirm': 'Confirmar',
      'signedInSuccessfully': 'Sesión iniciada exitosamente',
      'english': 'Inglés',
      'spanish': 'Español',
      'french': 'Francés',
      'german': 'Alemán',
      'dutch': 'Neerlandés',
      'arabic': 'Árabe',
      'chinese': 'Chino',
    },
    'fr': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Votre Assistant Documentaire IA',
      'loadingApplication': 'Chargement de l\'application',
      'pleaseUploadPdfFirst':
          'Veuillez d\'abord télécharger un PDF pour chatter',
      'home': 'Accueil',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Résumé',
      'signIn': 'Se Connecter',
      'signOut': 'Se Déconnecter',
      'uploadFile': 'Télécharger Fichier',
      'startQuiz': 'Commencer le Quiz',
      'next': 'Suivant',
      'previous': 'Précédent',
      'submit': 'Soumettre',
      'loading': 'Chargement...',
      'error': 'Une erreur est survenue',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Choisir la langue',
      'chatWithAny': 'Discutez avec n\'importe quel ',
      'document': 'Document',
      'uploadAndChatDescription':
          'Téléchargez un PDF et commencez à discuter avec votre document',
      'uploadPdfHere': 'Télécharger PDF ici',
      'tapToSelectFile': 'Appuyez pour sélectionner un fichier',
      'uploadPdf': 'Télécharger PDF',
      'chatWelcomeMessage':
          'Bonjour ! Je suis prêt à vous aider à comprendre "%fileName". Que souhaitez-vous savoir ?',
      'errorTryAgain':
          'Désolé, j\'ai rencontré une erreur. Veuillez réessayer.',
      'fileTypePdf': 'Type : Document PDF',
      'uploadedJustNow': 'Téléchargé : À l\'instant',
      'fileSize': 'Taille : %fileSize',
      'fileName': 'Nom : %fileName',
      'ok': 'OK',
      'noFileSelected': 'Aucun fichier sélectionné',
      'fileInformation': 'Informations du Fichier',
      'name': 'Nom',
      'noFile': 'Aucun fichier',
      'size': 'Taille',
      'analyzingDocument': 'Analyse du document et génération du résumé...',
      'mayTakeFewMoments': 'Cela peut prendre quelques instants',
      'failedToGenerateSummary': 'Échec de la génération du résumé',
      'tryAgain': 'Réessayer',
      'generateSummary': 'Générer le Résumé',
      'noDocumentUploaded': 'Aucun Document Téléchargé',
      'tapToGenerateSummary':
          'Appuyez ci-dessous pour analyser votre document et générer un résumé complet',
      'uploadFirstForSummary':
          'Téléchargez d\'abord un document pour générer un résumé alimenté par IA',
      'uploadDocument': 'Télécharger le Document',
      'Document': 'Document',
      'documentSummary': 'Résumé du Document',
      'aiGeneratedInsights': 'Informations générées par IA de',
      'executiveSummary': 'Résumé Exécutif',
      'conclusionsRecommendations': 'Conclusions et Recommandations',
      'keyFindings': 'Principales Constatations',
      'mainTopics': 'Sujets Principaux',
      'regenerate': 'Régénérer',
      'shareSummary': 'Partager le Résumé',
      'shareFunctionality': 'La fonctionnalité de partage s\'ouvrirait ici',
      'generatingQuiz': 'Génération du quiz à partir de votre document...',
      'documentQuiz': 'Quiz du Document',
      'generateQuizDescription':
          'Générez un quiz basé sur votre document téléchargé',
      'testUnderstanding': 'Testez votre compréhension du document',
      'generateQuizFromDocument': 'Générer le Quiz',
      'regenerateQuiz': 'Régénérer le Quiz',
      'checkAnswers': 'Vérifier les Réponses',
      'uploadPdfFirstForQuiz':
          'Veuillez d\'abord télécharger un PDF pour générer un quiz',
      'failedToGenerateQuiz': 'Échec de la génération du quiz',
      'recentFiles': 'Fichiers Récents',
      'noValidQuizQuestions': 'Aucune question de quiz valide n\'a été générée',
      'answerAllQuestions':
          'Veuillez répondre à toutes les %total questions. Vous avez répondu à %answered.',

      // New strings for features section
      'whatYouCanDo': 'Ce que vous pouvez faire',
      'chatDescription':
          'Discutez avec votre document et posez des questions sur son contenu',
      'summaryDescription':
          'Obtenez un résumé concis des points clés du document',
      'quizDescription':
          'Testez vos connaissances avec des questions basées sur le document',

      'signInToUpload': 'Connectez-vous pour télécharger des documents',
      'signInDescription':
          'Veuillez vous connecter avec votre compte Google ou Apple pour continuer le téléchargement de documents.',
      'signInWithGoogle': 'Se connecter avec Google',
      'signInWithApple': 'Se connecter avec Apple',
      'signingInWithGoogle': 'Connexion avec Google...',
      'signingInWithApple': 'Connexion avec Apple...',
      'googleSignInSuccess': 'Connecté avec Google avec succès !',
      'appleSignInSuccess': 'Connecté avec Apple avec succès !',
      'googleSignInFailed': 'Échec de la connexion Google. Veuillez réessayer.',
      'appleSignInFailed': 'Échec de la connexion Apple. Veuillez réessayer.',
      'googleSignInError': 'Erreur lors de la connexion Google :',
      'appleSignInError': 'Erreur lors de la connexion Apple :',
      'confirmSignOut': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'confirm': 'Confirmer',
      'signedInSuccessfully': 'Connecté avec succès',
      'cancel': 'Annuler',
      'english': 'Anglais',
      'spanish': 'Espagnol',
      'french': 'Français',
      'german': 'Allemand',
      'dutch': 'Néerlandais',
      'arabic': 'Arabe',
      'chinese': 'Chinois',
    },
    'de': {
      'appTitle': 'DocuSense AI',
      'tagline': 'Ihr KI-gestützter Dokumentenassistent',
      'loadingApplication': 'Anwendung wird geladen',
      'pleaseUploadPdfFirst':
          'Bitte laden Sie zuerst eine PDF hoch, um zu chatten',
      'home': 'Startseite',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Zusammenfassung',
      'signIn': 'Anmelden',
      'signOut': 'Abmelden',
      'uploadFile': 'Datei Hochladen',
      'startQuiz': 'Quiz Starten',
      'next': 'Weiter',
      'previous': 'Zurück',
      'submit': 'Einreichen',
      'loading': 'Lädt...',
      'error': 'Ein Fehler ist aufgetreten',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Sprache auswählen',
      'uploadPdfHere': 'PDF hier hochladen',
      'tapToSelectFile': 'Tippen, um eine Datei auszuwählen',
      'uploadPdf': 'PDF hochladen',
      'chatWelcomeMessage':
          'Hallo! Ich bin bereit, Ihnen zu helfen, "%fileName" zu verstehen. Was möchten Sie wissen?',
      'errorTryAgain':
          'Entschuldigung, es ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut.',
      'fileTypePdf': 'Typ: PDF-Dokument',
      'uploadedJustNow': 'Hochgeladen: Gerade eben',
      'fileSize': 'Größe: %fileSize',
      'fileName': 'Name: %fileName',
      'recentFiles': 'Kürzliche Dateien',
      'ok': 'OK',
      'noFileSelected': 'Keine Datei ausgewählt',
      'fileInformation': 'Dateiinformationen',
      'name': 'Name',
      'noFile': 'Keine Datei',
      'size': 'Größe',
      'analyzingDocument':
          'Dokument wird analysiert und Zusammenfassung generiert...',
      'mayTakeFewMoments': 'Dies kann einige Momente dauern',
      'failedToGenerateSummary':
          'Zusammenfassung konnte nicht generiert werden',
      'tryAgain': 'Erneut versuchen',
      'generateSummary': 'Zusammenfassung generieren',
      'noDocumentUploaded': 'Kein Dokument hochgeladen',
      'tapToGenerateSummary':
          'Tippen Sie unten, um Ihr Dokument zu analysieren und eine umfassende Zusammenfassung zu generieren',
      'uploadFirstForSummary':
          'Laden Sie zuerst ein Dokument hoch, um eine KI-gestützte Zusammenfassung zu generieren',
      'uploadDocument': 'Dokument hochladen',
      'Document': 'Dokument',
      'documentSummary': 'Dokumentenzusammenfassung',
      'aiGeneratedInsights': 'KI-generierte Einblicke aus',
      'executiveSummary': 'Management-Zusammenfassung',
      'conclusionsRecommendations': 'Schlussfolgerungen & Empfehlungen',
      'keyFindings': 'Wichtige Erkenntnisse',
      'mainTopics': 'Hauptthemen',
      'regenerate': 'Neu generieren',
      'shareSummary': 'Zusammenfassung teilen',
      'shareFunctionality': 'Teilen-Funktionalität würde hier geöffnet werden',
      'generatingQuiz': 'Quiz wird aus Ihrem Dokument generiert...',
      'documentQuiz': 'Dokumenten-Quiz',
      'generateQuizDescription':
          'Generieren Sie ein Quiz basierend auf Ihrem hochgeladenen Dokument',
      'testUnderstanding': 'Testen Sie Ihr Verständnis des Dokuments',
      'generateQuizFromDocument': 'Quiz generieren',
      'regenerateQuiz': 'Quiz neu generieren',
      'checkAnswers': 'Antworten überprüfen',
      'uploadPdfFirstForQuiz':
          'Bitte laden Sie zuerst ein PDF hoch, um ein Quiz zu generieren',
      'failedToGenerateQuiz': 'Quiz konnte nicht generiert werden',
      'noValidQuizQuestions': 'Es wurden keine gültigen Quizfragen generiert',
      'answerAllQuestions':
          'Bitte beantworten Sie alle %total Fragen. Sie haben %answered beantwortet.',

      // New strings for features section
      'whatYouCanDo': 'Was Sie tun können',
      'chatDescription':
          'Sprechen Sie mit Ihrem Dokument und stellen Sie Fragen zu seinem Inhalt',
      'summaryDescription':
          'Erhalten Sie eine prägnante Zusammenfassung der wichtigsten Punkte des Dokuments',
      'quizDescription':
          'Testen Sie Ihr Wissen mit Fragen basierend auf dem Dokument',
      'signInToUpload': 'Melden Sie sich an, um Dokumente hochzuladen',
      'signInDescription':
          'Bitte melden Sie sich mit Ihrem Google- oder Apple-Konto an, um mit dem Hochladen von Dokumenten fortzufahren.',
      'signInWithGoogle': 'Mit Google anmelden',
      'signInWithApple': 'Mit Apple anmelden',
      'signingInWithGoogle': 'Anmeldung mit Google...',
      'signingInWithApple': 'Anmeldung mit Apple...',
      'googleSignInSuccess': 'Erfolgreich mit Google angemeldet!',
      'appleSignInSuccess': 'Erfolgreich mit Apple angemeldet!',
      'googleSignInFailed':
          'Google-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.',
      'appleSignInFailed':
          'Apple-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.',
      'googleSignInError': 'Fehler bei der Google-Anmeldung:',
      'appleSignInError': 'Fehler bei der Apple-Anmeldung:',
      'cancel': 'Abbrechen',
      'confirmSignOut': 'Sind Sie sicher, dass Sie sich abmelden möchten?',
      'confirm': 'Bestätigen',
      'signedInSuccessfully': 'Erfolgreich angemeldet',
      'english': 'Englisch',
      'spanish': 'Spanisch',
      'french': 'Französisch',
      'german': 'Deutsch',
      'dutch': 'Niederländisch',
      'arabic': 'Arabisch',
      'chinese': 'Chinesisch',
    },
    'nl': {
      'recentFiles': 'Recente Bestanden',
      'appTitle': 'DocuSense AI',
      'tagline': 'Uw AI-aangedreven Documentassistent',
      'loadingApplication': 'Applicatie laden',
      'pleaseUploadPdfFirst': 'Upload eerst een PDF om te chatten',
      'home': 'Home',
      'chat': 'Chat',
      'quiz': 'Quiz',
      'summary': 'Samenvatting',
      'signIn': 'Inloggen',
      'signOut': 'Uitloggen',
      'uploadFile': 'Bestand Uploaden',
      'startQuiz': 'Start Quiz',
      'next': 'Volgende',
      'previous': 'Vorige',
      'submit': 'Indienen',
      'loading': 'Laden...',
      'error': 'Er is een fout opgetreden',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'Selecteer taal',
      'chatWithAny': 'Chat met elk ',
      'document': 'Document',
      'uploadAndChatDescription':
          'Upload een PDF en begin te chatten met je document',
      'uploadPdfHere': 'PDF hier uploaden',
      'tapToSelectFile': 'Tik om een bestand te selecteren',
      'uploadPdf': 'PDF uploaden',
      'chatWelcomeMessage':
          'Hallo! Ik ben klaar om u te helpen "%fileName" te begrijpen. Wat wilt u weten?',
      'errorTryAgain':
          'Sorry, ik heb een fout tegengekomen. Probeer het opnieuw.',
      'fileTypePdf': 'Type: PDF-document',
      'uploadedJustNow': 'Geüpload: Zojuist',
      'fileSize': 'Grootte: %fileSize',
      'fileName': 'Naam: %fileName',
      'ok': 'OK',
      'noFileSelected': 'Geen bestand geselecteerd',
      'fileInformation': 'Bestandsinformatie',
      'name': 'Naam',
      'noFile': 'Geen bestand',
      'size': 'Grootte',
      'analyzingDocument': 'Document analyseren en samenvatting genereren...',
      'mayTakeFewMoments': 'Dit kan even duren',
      'failedToGenerateSummary': 'Kan samenvatting niet genereren',
      'tryAgain': 'Opnieuw proberen',
      'generateSummary': 'Samenvatting genereren',
      'noDocumentUploaded': 'Geen document geüpload',
      'tapToGenerateSummary':
          'Tik hieronder om uw document te analyseren en een uitgebreide samenvatting te genereren',
      'uploadFirstForSummary':
          'Upload eerst een document om een AI-aangedreven samenvatting te genereren',
      'uploadDocument': 'Document uploaden',
      'Document': 'Document',
      'documentSummary': 'Documentsamenvatting',
      'aiGeneratedInsights': 'AI-gegenereerde inzichten van',
      'executiveSummary': 'Executive Samenvatting',
      'conclusionsRecommendations': 'Conclusies & Aanbevelingen',
      'keyFindings': 'Belangrijke bevindingen',
      'mainTopics': 'Hoofdonderwerpen',
      'regenerate': 'Opnieuw genereren',
      'shareSummary': 'Samenvatting delen',
      'shareFunctionality': 'Deelfunctionaliteit zou hier openen',
      'generatingQuiz': 'Quiz genereren vanuit uw document...',
      'documentQuiz': 'Document Quiz',
      'generateQuizDescription':
          'Genereer een quiz op basis van uw geüploade document',
      'testUnderstanding': 'Test uw begrip van het document',
      'generateQuizFromDocument': 'Quiz genereren',
      'regenerateQuiz': 'Quiz opnieuw genereren',
      'checkAnswers': 'Antwoorden controleren',
      'uploadPdfFirstForQuiz': 'Upload eerst een PDF om een quiz te genereren',
      'failedToGenerateQuiz': 'Kan quiz niet genereren',
      'noValidQuizQuestions': 'Er zijn geen geldige quizvragen gegenereerd',
      'answerAllQuestions':
          'Beantwoord alle %total vragen. U heeft %answered beantwoord.',

      // New strings for features section
      'whatYouCanDo': 'Wat je kunt doen',
      'chatDescription': 'Praat met je document en stel vragen over de inhoud',
      'summaryDescription':
          'Krijg een beknopte samenvatting van de belangrijkste punten in het document',
      'quizDescription': 'Test je kennis met vragen gebaseerd op het document',
      'signInToUpload': 'Log in om documenten te uploaden',
      'signInDescription':
          'Log in met uw Google- of Apple-account om door te gaan met het uploaden van documenten.',
      'signInWithGoogle': 'Inloggen met Google',
      'signInWithApple': 'Inloggen met Apple',
      'signingInWithGoogle': 'Inloggen met Google...',
      'signingInWithApple': 'Inloggen met Apple...',
      'googleSignInSuccess': 'Succesvol ingelogd met Google!',
      'appleSignInSuccess': 'Succesvol ingelogd met Apple!',
      'googleSignInFailed': 'Google-inloggen mislukt. Probeer het opnieuw.',
      'appleSignInFailed': 'Apple-inloggen mislukt. Probeer het opnieuw.',
      'googleSignInError': 'Fout tijdens Google-inloggen:',
      'appleSignInError': 'Fout tijdens Apple-inloggen:',
      'cancel': 'Annuleren',
      'confirmSignOut': 'Weet u zeker dat u wilt uitloggen?',
      'confirm': 'Bevestigen',
      'signedInSuccessfully': 'Succesvol ingelogd',
      'english': 'Engels',
      'spanish': 'Spaans',
      'french': 'Frans',
      'german': 'Duits',
      'dutch': 'Nederlands',
      'arabic': 'Arabisch',
      'chinese': 'Chinees',
    },
    'ar': {
      'appTitle': 'DocuSense AI',
      'tagline': 'مساعدك الذكي للمستندات',
      'recentFiles': 'الملفات الحديثة',
      'loadingApplication': 'جاري تحميل التطبيق',
      'pleaseUploadPdfFirst': 'يرجى تحميل ملف PDF أولاً للبدء في الدردشة',
      'home': 'الرئيسية',
      'chat': 'الدردشة',
      'quiz': 'الاختبار',
      'summary': 'ملخص',
      'signIn': 'تسجيل الدخول',
      'signOut': 'تسجيل الخروج',
      'uploadFile': 'رفع ملف',
      'startQuiz': 'بدء الاختبار',
      'next': 'التالي',
      'previous': 'السابق',
      'submit': 'إرسال',
      'loading': 'جاري التحميل...',
      'error': 'حدث خطأ',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': 'اختر اللغة',
      'chatWithAny': 'تحدث مع أي ',
      'document': 'مستند',
      'uploadAndChatDescription': 'قم بتحميل ملف PDF وابدأ الدردشة مع مستندك',
      'chatWelcomeMessage':
          'مرحباً! أنا مستعد لمساعدتك في فهم "%fileName". ماذا تريد أن تعرف؟',
      'errorTryAgain': 'عذراً، واجهت خطأ. يرجى المحاولة مرة أخرى.',
      'fileTypePdf': 'النوع: مستند PDF',
      'uploadedJustNow': 'تم الرفع: الآن',
      'fileSize': 'الحجم: %fileSize',
      'fileName': 'الاسم: %fileName',
      'ok': 'موافق',
      'noFileSelected': 'لم يتم اختيار ملف',
      'fileInformation': 'معلومات الملف',
      'name': 'الاسم',
      'noFile': 'لا يوجد ملف',
      'size': 'الحجم',
      'analyzingDocument': 'جاري تحليل المستند وإنشاء الملخص...',
      'mayTakeFewMoments': 'قد يستغرق هذا بضع لحظات',
      'failedToGenerateSummary': 'فشل في إنشاء الملخص',
      'tryAgain': 'حاول مرة أخرى',
      'generateSummary': 'إنشاء الملخص',
      'noDocumentUploaded': 'لم يتم رفع أي مستند',
      'tapToGenerateSummary': 'انقر أدناه لتحليل مستندك وإنشاء ملخص شامل',
      'uploadFirstForSummary':
          'قم برفع مستند أولاً لإنشاء ملخص مدعوم بالذكاء الاصطناعي',
      'uploadDocument': 'رفع المستند',
      'Document': 'المستند',
      'documentSummary': 'ملخص المستند',
      'aiGeneratedInsights': 'رؤى مولدة بالذكاء الاصطناعي من',
      'executiveSummary': 'ملخص تنفيذي',
      'conclusionsRecommendations': 'الاستنتاجات والتوصيات',
      'keyFindings': 'النتائج الرئيسية',
      'mainTopics': 'المواضيع الرئيسية',
      'regenerate': 'إعادة إنشاء',
      'shareSummary': 'مشاركة الملخص',
      'shareFunctionality': 'ستفتح وظيفة المشاركة هنا',
      'generatingQuiz': 'جاري إنشاء الاختبار من مستندك...',
      'documentQuiz': 'اختبار المستند',
      'generateQuizDescription':
          'قم بإنشاء اختبار بناءً على المستند الذي قمت برفعه',
      'testUnderstanding': 'اختبر فهمك للمستند',
      'generateQuizFromDocument': 'إنشاء اختبار',
      'regenerateQuiz': 'إعادة إنشاء الاختبار',
      'checkAnswers': 'التحقق من الإجابات',
      'uploadPdfFirstForQuiz': 'يرجى رفع ملف PDF أولاً لإنشاء اختبار',
      'failedToGenerateQuiz': 'فشل في إنشاء الاختبار',
      'noValidQuizQuestions': 'لم يتم إنشاء أسئلة اختبار صالحة',
      'answerAllQuestions':
          'يرجى الإجابة على جميع الأسئلة %total. لقد أجبت على %answered.',

      // New strings for features section
      'whatYouCanDo': 'ما يمكنك القيام به',
      'chatDescription': 'تحدث مع مستندك واطرح أسئلة حول محتواه',
      'summaryDescription': 'احصل على ملخص موجز للنقاط الرئيسية في المستند',
      'quizDescription': 'اختبر معرفتك بأسئلة مبنية على المستند',
      'signInToUpload': 'سجل الدخول لرفع المستندات',
      'signInDescription':
          'يرجى تسجيل الدخول باستخدام حساب Google أو Apple للمتابعة في رفع المستندات.',
      'signInWithGoogle': 'تسجيل الدخول باستخدام Google',
      'signInWithApple': 'تسجيل الدخول باستخدام Apple',
      'signingInWithGoogle': 'جاري تسجيل الدخول باستخدام Google...',
      'signingInWithApple': 'جاري تسجيل الدخول باستخدام Apple...',
      'googleSignInSuccess': 'تم تسجيل الدخول باستخدام Google بنجاح!',
      'appleSignInSuccess': 'تم تسجيل الدخول باستخدام Apple بنجاح!',
      'googleSignInFailed':
          'فشل تسجيل الدخول باستخدام Google. يرجى المحاولة مرة أخرى.',
      'appleSignInFailed':
          'فشل تسجيل الدخول باستخدام Apple. يرجى المحاولة مرة أخرى.',
      'googleSignInError': 'خطأ أثناء تسجيل الدخول باستخدام Google:',
      'appleSignInError': 'خطأ أثناء تسجيل الدخول باستخدام Apple:',
      'cancel': 'إلغاء',
      'confirmSignOut': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'confirm': 'تأكيد',
      'signedInSuccessfully': 'تم تسجيل الدخول بنجاح',
      'english': 'الإنجليزية',
      'spanish': 'الإسبانية',
      'french': 'الفرنسية',
      'german': 'الألمانية',
      'dutch': 'الهولندية',
      'arabic': 'العربية',
      'chinese': 'الصينية',
    },
    'zh': {
      'appTitle': 'DocuSense AI',
      'tagline': '您的AI驱动文档助手',
      'loadingApplication': '正在加载应用程序',
      'pleaseUploadPdfFirst': '请先上传PDF文件开始聊天',
      'home': '首页',
      'recentFiles': '最近文件',
      'chat': '聊天',
      'quiz': '测验',
      'summary': '摘要',
      'signIn': '登录',
      'signOut': '退出',
      'uploadFile': '上传文件',
      'startQuiz': '开始测验',
      'next': '下一步',
      'previous': '上一步',
      'submit': '提交',
      'loading': '加载中...',
      'error': '发生错误',
      'copyright': '© 2025 DocuSense AI',
      'selectLanguage': '选择语言',
      'chatWithAny': '与任何',
      'document': '文档聊天',
      'uploadAndChatDescription': '上传PDF文件并开始与您的文档聊天',
      'uploadPdfHere': '在此上传PDF',
      'tapToSelectFile': '点击选择文件',
      'uploadPdf': '上传PDF',
      'chatWelcomeMessage': '你好！我准备好帮您理解"%fileName"。您想了解什么？',
      'errorTryAgain': '抱歉，我遇到了错误。请重试。',
      'fileTypePdf': '类型：PDF文档',
      'uploadedJustNow': '上传时间：刚刚',
      'fileSize': '大小：%fileSize',
      'fileName': '名称：%fileName',
      'ok': '确定',
      'noFileSelected': '未选择文件',
      'fileInformation': '文件信息',
      'name': '名称',
      'noFile': '无文件',
      'size': '大小',
      'analyzingDocument': '正在分析文档并生成摘要...',
      'mayTakeFewMoments': '这可能需要一些时间',
      'failedToGenerateSummary': '生成摘要失败',
      'tryAgain': '重试',
      'generateSummary': '生成摘要',
      'noDocumentUploaded': '未上传文档',
      'tapToGenerateSummary': '点击下方分析您的文档并生成全面摘要',
      'uploadFirstForSummary': '请先上传文档以生成AI驱动的摘要',
      'uploadDocument': '上传文档',
      'Document': '文档',
      'documentSummary': '文档摘要',
      'aiGeneratedInsights': 'AI生成的见解来自',
      'executiveSummary': '执行摘要',
      'conclusionsRecommendations': '结论与建议',
      'keyFindings': '关键发现',
      'mainTopics': '主要主题',
      'regenerate': '重新生成',
      'shareSummary': '分享摘要',
      'shareFunctionality': '分享功能将在此处打开',
      'generatingQuiz': '正在从您的文档生成测验...',
      'documentQuiz': '文档测验',
      'generateQuizDescription': '基于您上传的文档生成测验',
      'testUnderstanding': '测试您对文档的理解',
      'generateQuizFromDocument': '生成测验',
      'regenerateQuiz': '重新生成测验',
      'checkAnswers': '检查答案',
      'uploadPdfFirstForQuiz': '请先上传PDF以生成测验',
      'failedToGenerateQuiz': '生成测验失败',
      'noValidQuizQuestions': '未生成有效的测验问题',
      'answerAllQuestions': '请回答所有%total个问题。您已回答了%answered个。',

      // New strings for features section
      'whatYouCanDo': '您可以做什么',
      'chatDescription': '与您的文档聊天并就其内容提问',
      'summaryDescription': '获取文档关键要点的简明摘要',
      'quizDescription': '通过基于文档的问题测试您的知识',
      'signInToUpload': '登录以上传文档',
      'signInDescription': '请使用您的 Google 或 Apple 账户登录以继续上传文档。',
      'signInWithGoogle': '使用 Google 登录',
      'signInWithApple': '使用 Apple 登录',
      'signingInWithGoogle': '正在使用 Google 登录...',
      'signingInWithApple': '正在使用 Apple 登录...',
      'googleSignInSuccess': '使用 Google 登录成功！',
      'appleSignInSuccess': '使用 Apple 登录成功！',
      'googleSignInFailed': 'Google 登录失败。请重试。',
      'appleSignInFailed': 'Apple 登录失败。请重试。',
      'googleSignInError': 'Google 登录期间出错：',
      'appleSignInError': 'Apple 登录期间出错：',
      'cancel': '取消',
      'confirmSignOut': '您确定要退出登录吗？',
      'confirm': '确认',
      'english': '英语',
      'spanish': '西班牙语',
      'french': '法语',
      'german': '德语',
      'dutch': '荷兰语',
      'arabic': '阿拉伯语',
      'chinese': '中文',
      'signedInSuccessfully': '登录成功',
    },
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]!['appTitle']!;
  }

  String get tagline {
    return _localizedValues[locale.languageCode]!['tagline']!;
  }

  String get loadingApplication {
    return _localizedValues[locale.languageCode]!['loadingApplication']!;
  }

  String get pleaseUploadPdfFirst {
    return _localizedValues[locale.languageCode]!['pleaseUploadPdfFirst']!;
  }

  String get home {
    return _localizedValues[locale.languageCode]!['home']!;
  }

  String get chat {
    return _localizedValues[locale.languageCode]!['chat']!;
  }

  String get quiz {
    return _localizedValues[locale.languageCode]!['quiz']!;
  }

  String get summary {
    return _localizedValues[locale.languageCode]!['summary']!;
  }

  String get signIn {
    return _localizedValues[locale.languageCode]!['signIn']!;
  }

  String get signOut {
    return _localizedValues[locale.languageCode]!['signOut']!;
  }

  String get recentFiles =>
      _localizedValues[locale.languageCode]!['recentFiles']!;

  String get uploadFile {
    return _localizedValues[locale.languageCode]!['uploadFile']!;
  }

  String get startQuiz {
    return _localizedValues[locale.languageCode]!['startQuiz']!;
  }

  String get next {
    return _localizedValues[locale.languageCode]!['next']!;
  }

  String get previous {
    return _localizedValues[locale.languageCode]!['previous']!;
  }

  String get submit {
    return _localizedValues[locale.languageCode]!['submit']!;
  }

  String get loading {
    return _localizedValues[locale.languageCode]!['loading']!;
  }

  String get error {
    return _localizedValues[locale.languageCode]!['error']!;
  }

  String get copyright {
    return _localizedValues[locale.languageCode]!['copyright']!;
  }

  String get selectLanguage {
    return _localizedValues[locale.languageCode]!['selectLanguage']!;
  }

  String get chatWithAny {
    return _localizedValues[locale.languageCode]!['chatWithAny']!;
  }

  String get document {
    return _localizedValues[locale.languageCode]!['document']!;
  }

  String get uploadAndChatDescription {
    return _localizedValues[locale.languageCode]!['uploadAndChatDescription']!;
  }

  String get uploadPdfHere {
    return _localizedValues[locale.languageCode]!['uploadPdfHere']!;
  }

  String get tapToSelectFile {
    return _localizedValues[locale.languageCode]!['tapToSelectFile']!;
  }

  String get uploadPdf {
    return _localizedValues[locale.languageCode]!['uploadPdf']!;
  }

  String get chatWelcomeMessage {
    return _localizedValues[locale.languageCode]!['chatWelcomeMessage']!;
  }

  String get errorTryAgain {
    return _localizedValues[locale.languageCode]!['errorTryAgain']!;
  }

  String get fileTypePdf {
    return _localizedValues[locale.languageCode]!['fileTypePdf']!;
  }

  String get uploadedJustNow {
    return _localizedValues[locale.languageCode]!['uploadedJustNow']!;
  }

  String get fileSize {
    return _localizedValues[locale.languageCode]!['fileSize']!;
  }

  String get fileName {
    return _localizedValues[locale.languageCode]!['fileName']!;
  }

  String get ok {
    return _localizedValues[locale.languageCode]!['ok']!;
  }

  String get noFileSelected {
    return _localizedValues[locale.languageCode]!['noFileSelected']!;
  }

  String get fileInformation {
    return _localizedValues[locale.languageCode]!['fileInformation']!;
  }

  String get name {
    return _localizedValues[locale.languageCode]!['name']!;
  }

  String get noFile {
    return _localizedValues[locale.languageCode]!['noFile']!;
  }

  String get size {
    return _localizedValues[locale.languageCode]!['size']!;
  }

  // Add these to AppLocalizations class:

  String get analyzingDocument =>
      _localizedValues[locale.languageCode]!['analyzingDocument']!;
  String get mayTakeFewMoments =>
      _localizedValues[locale.languageCode]!['mayTakeFewMoments']!;
  String get failedToGenerateSummary =>
      _localizedValues[locale.languageCode]!['failedToGenerateSummary']!;
  String get tryAgain => _localizedValues[locale.languageCode]!['tryAgain']!;
  String get generateSummary =>
      _localizedValues[locale.languageCode]!['generateSummary']!;
  String get noDocumentUploaded =>
      _localizedValues[locale.languageCode]!['noDocumentUploaded']!;
  String get tapToGenerateSummary =>
      _localizedValues[locale.languageCode]!['tapToGenerateSummary']!;
  String get uploadFirstForSummary =>
      _localizedValues[locale.languageCode]!['uploadFirstForSummary']!;
  String get uploadDocument =>
      _localizedValues[locale.languageCode]!['uploadDocument']!;
  String get Document => _localizedValues[locale.languageCode]!['document']!;
  String get documentSummary =>
      _localizedValues[locale.languageCode]!['documentSummary']!;
  String get aiGeneratedInsights =>
      _localizedValues[locale.languageCode]!['aiGeneratedInsights']!;
  String get executiveSummary =>
      _localizedValues[locale.languageCode]!['executiveSummary']!;
  String get conclusionsRecommendations =>
      _localizedValues[locale.languageCode]!['conclusionsRecommendations']!;
  String get keyFindings =>
      _localizedValues[locale.languageCode]!['keyFindings']!;
  String get mainTopics =>
      _localizedValues[locale.languageCode]!['mainTopics']!;
  String get regenerate =>
      _localizedValues[locale.languageCode]!['regenerate']!;
  String get shareSummary =>
      _localizedValues[locale.languageCode]!['shareSummary']!;
  String get shareFunctionality =>
      _localizedValues[locale.languageCode]!['shareFunctionality']!;

  // Add these to AppLocalizations class:

  String get generatingQuiz =>
      _localizedValues[locale.languageCode]!['generatingQuiz']!;
  String get documentQuiz =>
      _localizedValues[locale.languageCode]!['documentQuiz']!;
  String get generateQuizDescription =>
      _localizedValues[locale.languageCode]!['generateQuizDescription']!;
  String get testUnderstanding =>
      _localizedValues[locale.languageCode]!['testUnderstanding']!;
  String get generateQuizFromDocument =>
      _localizedValues[locale.languageCode]!['generateQuizFromDocument']!;
  String get regenerateQuiz =>
      _localizedValues[locale.languageCode]!['regenerateQuiz']!;
  String get checkAnswers =>
      _localizedValues[locale.languageCode]!['checkAnswers']!;
  String get uploadPdfFirstForQuiz =>
      _localizedValues[locale.languageCode]!['uploadPdfFirstForQuiz']!;
  String get failedToGenerateQuiz =>
      _localizedValues[locale.languageCode]!['failedToGenerateQuiz']!;
  String get noValidQuizQuestions =>
      _localizedValues[locale.languageCode]!['noValidQuizQuestions']!;
  String get answerAllQuestions =>
      _localizedValues[locale.languageCode]!['answerAllQuestions']!;

  // New getters for features section
  String get whatYouCanDo =>
      _localizedValues[locale.languageCode]!['whatYouCanDo']!;
  String get chatDescription =>
      _localizedValues[locale.languageCode]!['chatDescription']!;
  String get summaryDescription =>
      _localizedValues[locale.languageCode]!['summaryDescription']!;
  String get quizDescription =>
      _localizedValues[locale.languageCode]!['quizDescription']!;

  // Add these to AppLocalizations class:

  String get signInToUpload =>
      _localizedValues[locale.languageCode]!['signInToUpload']!;
  String get signInDescription =>
      _localizedValues[locale.languageCode]!['signInDescription']!;
  String get signInWithGoogle =>
      _localizedValues[locale.languageCode]!['signInWithGoogle']!;
  String get signInWithApple =>
      _localizedValues[locale.languageCode]!['signInWithApple']!;
  String get signingInWithGoogle =>
      _localizedValues[locale.languageCode]!['signingInWithGoogle']!;
  String get signingInWithApple =>
      _localizedValues[locale.languageCode]!['signingInWithApple']!;
  String get googleSignInSuccess =>
      _localizedValues[locale.languageCode]!['googleSignInSuccess']!;
  String get appleSignInSuccess =>
      _localizedValues[locale.languageCode]!['appleSignInSuccess']!;
  String get googleSignInFailed =>
      _localizedValues[locale.languageCode]!['googleSignInFailed']!;
  String get appleSignInFailed =>
      _localizedValues[locale.languageCode]!['appleSignInFailed']!;
  String get googleSignInError =>
      _localizedValues[locale.languageCode]!['googleSignInError']!;
  String get appleSignInError =>
      _localizedValues[locale.languageCode]!['appleSignInError']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;

  // Add these to AppLocalizations class:

  String get confirmSignOut =>
      _localizedValues[locale.languageCode]!['confirmSignOut']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get signedInSuccessfully =>
      _localizedValues[locale.languageCode]!['signedInSuccessfully']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get spanish => _localizedValues[locale.languageCode]!['spanish']!;
  String get french => _localizedValues[locale.languageCode]!['french']!;
  String get german => _localizedValues[locale.languageCode]!['german']!;
  String get dutch => _localizedValues[locale.languageCode]!['dutch']!;
  String get arabic => _localizedValues[locale.languageCode]!['arabic']!;
  String get chinese => _localizedValues[locale.languageCode]!['chinese']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'es',
      'fr',
      'de',
      'nl',
      'ar',
      'zh',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

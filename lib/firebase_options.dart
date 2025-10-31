import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static final FirebaseOptions webOptions = FirebaseOptions(
    apiKey: "AIzaSyDH9-bSf-9Xvu6eSFCIU50Hsg_nXBG2GZ0",
    appId: "1:911196821203:web:a260ef48342e33af0d6626",
    messagingSenderId: "911196821203",
    projectId: "englishapp-c6bf8",
    authDomain: "englishapp-c6bf8.firebaseapp.com",
    storageBucket: "englishapp-c6bf8.firebasestorage.app",
  );

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: webOptions);
  }
}
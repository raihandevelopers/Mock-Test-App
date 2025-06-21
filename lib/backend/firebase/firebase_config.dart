import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBSH6xKQGsdxfR9uScI1mgc9OCe-dL7858",
            authDomain: "mock-test-f74e7.firebaseapp.com",
            projectId: "mock-test-f74e7",
            storageBucket: "mock-test-f74e7.firebasestorage.app",
            messagingSenderId: "161514790490",
            appId: "1:161514790490:android:37a429dd0f3bc015a34263"));
  } else {
    await Firebase.initializeApp();
  }
}

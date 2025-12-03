// Scaffold adapter for Firebase Authentication.
//
// Purpose:
// - Provide a small adapter that maps Firebase Auth users to the app's
//   `User` model and exposes the same async methods used by
//   `AuthenticationService` (signInWithEmail, signUpWithEmail, signInWithGoogle,
//   signOut, init/currentUser). This file is intentionally isolated so you can
//   add the Firebase packages to `pubspec.yaml` and enable it when ready.
//
// To enable:
// 1. Add to pubspec.yaml (example versions - pick the latest compatible):
//    firebase_core: ^2.20.0
//    firebase_auth: ^4.8.0
//    google_sign_in: ^6.1.0    # optional, for Google sign-in on mobile
// 2. Run `flutter pub get` and follow platform setup for Firebase (Android/iOS/web).
// 3. Replace usage of the plain AuthenticationService methods (or call into
//    this adapter from AuthenticationService).

// This adapter implements a small wrapper around the `firebase_auth` APIs.
// It expects Firebase to be initialized (call `Firebase.initializeApp()` in
// `main()` before using it). The adapter maps Firebase `User` -> app `User`.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:union_shop/data/user.dart';

class FirebaseAuthAdapter {
  // Call this during app startup after Firebase.initializeApp() if you use it.
  FirebaseAuthAdapter._private();
  static final FirebaseAuthAdapter _instance = FirebaseAuthAdapter._private();
  factory FirebaseAuthAdapter() => _instance;

  // Example: map Firebase User to our User model.
  // helper: map Firebase `fb.User?` to app `User?`
  static User? _fromFirebaseUser(fb.User? fu) {
    if (fu == null) return null;
    return User(
      id: fu.uid,
      email: fu.email ?? '',
      name: fu.displayName,
    );
  }

  // Public helper to map Firebase user to app User
  static User? mapFirebaseUser(fb.User? fu) => _fromFirebaseUser(fu);

  // Example placeholder methods. Replace the bodies with real Firebase calls
  // after adding the `firebase_auth` package.

  Future<void> init() async {
    // Ensure Firebase is initialized. If already initialized, this is a no-op.
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // ignore: no-op; initialization may have been done elsewhere
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    final cred = await fb.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = _fromFirebaseUser(cred.user);
    if (user == null) throw Exception('Failed to sign in');
    return user;
  }

  Future<User> signUpWithEmail(String email, String password) async {
    final cred = await fb.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = _fromFirebaseUser(cred.user);
    if (user == null) throw Exception('Failed to sign up');
    return user;
  }

  Future<User> signInWithGoogle() async {
    // Web flow: use FirebaseAuth popup. For mobile, add `google_sign_in` and
    // implement the native flow.
    if (kIsWeb) {
      final provider = fb.GoogleAuthProvider();
      // Try to force an interactive re-consent/login so the user must choose
      // or enter an account instead of silently using an existing Google
      // session. `consent` forces the consent screen which typically prevents
      // silent auto-signin; `select_account` shows the account chooser.
      // Some browsers / SSO states may still auto-select an account. If that
      // happens, the only reliable workaround is to sign the user out of their
      // Google session or use a redirect flow.
      provider.setCustomParameters({'prompt': 'consent'});
      final userCred = await fb.FirebaseAuth.instance.signInWithPopup(provider);
      final user = _fromFirebaseUser(userCred.user);
      if (user == null) throw Exception('Failed to sign in with Google');
      return user;
    }
    throw UnimplementedError(
        'Google sign-in for mobile not implemented; add google_sign_in and implement the flow');
  }

  Future<void> signOut() async {
    await fb.FirebaseAuth.instance.signOut();
  }

  User? get currentUser {
    return _fromFirebaseUser(fb.FirebaseAuth.instance.currentUser);
  }
}

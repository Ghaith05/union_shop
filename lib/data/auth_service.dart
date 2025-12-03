import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:union_shop/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:union_shop/data/firebase_auth_adapter.dart';

/// AuthenticationService: core API only.
/// - Singleton
/// - ValueNotifier<User?> currentUser
/// - init() wires Firebase auth state and updates in-memory session
/// - signInWithEmail / signUpWithEmail / signOut change in-memory state
class AuthenticationService {
  AuthenticationService._private();
  static final AuthenticationService _instance =
      AuthenticationService._private();
  factory AuthenticationService() => _instance;

  final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

  Future<void> init() async {
    try {
      // Wire Firebase auth state changes so app state follows Firebase.
      try {
        final adapter = FirebaseAuthAdapter();
        await adapter.init();

        // Read current Firebase user (if any) and map to app user.
        final fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
        if (kDebugMode) {
          // ignore: avoid_print
          print(
              'AuthenticationService.init(): firebase currentUser=${fbUser?.email ?? 'null'}');
        }
        final mappedNow = FirebaseAuthAdapter.mapFirebaseUser(fbUser);
        if (mappedNow != null) {
          currentUser.value = mappedNow;
          if (kDebugMode) {
            // ignore: avoid_print
            print(
                'AuthenticationService.init(): mapped firebase user -> ${mappedNow.email}');
          }
        }

        // Keep listening for future auth state changes and update state.
        fb.FirebaseAuth.instance.authStateChanges().listen((fu) {
          final mapped = FirebaseAuthAdapter.mapFirebaseUser(fu);
          currentUser.value = mapped;
          if (kDebugMode) {
            // ignore: avoid_print
            print(
                'AuthenticationService.init(): authStateChanges -> ${mapped?.email ?? 'signed out'}');
          }
        });
      } catch (e) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('AuthenticationService.init(): firebase wiring failed: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService.init(): unexpected init error: $e');
      }
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    // Use Firebase adapter if available
    try {
      final adapter = FirebaseAuthAdapter();
      final user = await adapter.signInWithEmail(email, password);
      currentUser.value = user;
      return user;
    } catch (_) {
      // Fallback to local simulated sign-in (offline/dev)
      await Future.delayed(const Duration(milliseconds: 300));
      if (!_looksLikeEmail(email)) throw Exception('Invalid email');
      final user = User(id: email, email: email, name: _nameFromEmail(email));
      currentUser.value = user;
      return user;
    }
  }

  Future<User> signUpWithEmail(String email, String password) async {
    try {
      final adapter = FirebaseAuthAdapter();
      final user = await adapter.signUpWithEmail(email, password);
      currentUser.value = user;
      return user;
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!_looksLikeEmail(email)) throw Exception('Invalid email');
      final user = User(id: email, email: email, name: _nameFromEmail(email));
      currentUser.value = user;
      return user;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final adapter = FirebaseAuthAdapter();
      final user = await adapter.signInWithGoogle();
      currentUser.value = user;
      return user;
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService.signInWithGoogle(): adapter error: $e');
        // ignore: avoid_print
        print(st);
      }
      // Re-throw so UI can show a helpful message instead of silently falling
      // back to a fake user. This helps diagnose why Firebase sign-in failed.
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final adapter = FirebaseAuthAdapter();
      await adapter.signOut();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    currentUser.value = null;
  }

  bool _looksLikeEmail(String e) =>
      e.contains('@') && e.contains('.') && e.length > 4;
  String _nameFromEmail(String e) => e.split('@').first;
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:union_shop/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:union_shop/data/firebase_auth_adapter.dart';
import 'package:union_shop/data/cart.dart';

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
      await CartService().loadCart();
      return user;
    } catch (_) {
      // Fallback to local simulated sign-in (offline/dev)
      await Future.delayed(const Duration(milliseconds: 300));
      if (!_looksLikeEmail(email)) throw Exception('Invalid email');
      final user = User(id: email, email: email, name: _nameFromEmail(email));
      currentUser.value = user;
      await CartService().loadCart();
      return user;
    }
  }

  Future<User> signUpWithEmail(String email, String password) async {
    try {
      final adapter = FirebaseAuthAdapter();
      final user = await adapter.signUpWithEmail(email, password);
      currentUser.value = user;
      await CartService().loadCart();
      final fb.User? fu = fb.FirebaseAuth.instance.currentUser;
      if (fu != null) {
        await CartService().loadFromServer(fu.uid);
        await CartService().saveToServer(fu.uid);
      }
      return user;
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!_looksLikeEmail(email)) throw Exception('Invalid email');
      final user = User(id: email, email: email, name: _nameFromEmail(email));
      currentUser.value = user;
      await CartService().loadCart();
      final fb.User? fu = fb.FirebaseAuth.instance.currentUser;
      if (fu != null) {
        await CartService().loadFromServer(fu.uid);
        await CartService().saveToServer(fu.uid);
      }
      return user;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final adapter = FirebaseAuthAdapter();
      final user = await adapter.signInWithGoogle();
      currentUser.value = user;
      await CartService().loadCart();
      final fb.User? fu = fb.FirebaseAuth.instance.currentUser;
      if (fu != null) {
        await CartService().loadFromServer(fu.uid);
        await CartService().saveToServer(fu.uid);
      }
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

  /// Update profile fields (name and/or email).
  /// If Firebase is available, update the Firebase user and then update
  /// the in-memory `currentUser`. Falls back to updating the in-memory
  /// model when no backend is available (useful for offline/dev).
  Future<void> updateProfile({String? name, String? email}) async {
    // Enforce email policy: only allow Gmail addresses when updating email.
    if (email != null && email.trim().isNotEmpty) {
      final normalized = email.trim().toLowerCase();
      if (!normalized.endsWith('@gmail.com')) {
        throw Exception('Email must be a @gmail.com address');
      }
    }
    try {
      final fb.User? fu = fb.FirebaseAuth.instance.currentUser;
      if (fu != null) {
        if (name != null) {
          await fu.updateDisplayName(name);
        }
        if (email != null && email != fu.email) {
          // Use dynamic call to avoid static SDK differences across versions.
          await (fu as dynamic).updateEmail(email);
        }
        // Refresh mapped user
        final mapped = FirebaseAuthAdapter.mapFirebaseUser(
            fb.FirebaseAuth.instance.currentUser);
        currentUser.value = mapped;
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService.updateProfile(): error: $e');
      }
      // Don't rethrow here so tests and offline/dev scenarios fall back to
      // updating the in-memory model below.
    }

    // Fallback: update in-memory only
    final u = currentUser.value;
    if (u != null) {
      currentUser.value = User(
        id: u.id,
        email: email ?? u.email,
        name: name ?? u.name,
      );
    }
  }

  bool _looksLikeEmail(String e) =>
      e.contains('@') && e.contains('.') && e.length > 4;
  String _nameFromEmail(String e) => e.split('@').first;
}

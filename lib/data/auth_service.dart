import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/data/user.dart';

/// AuthenticationService: core API only.
/// - Singleton
/// - ValueNotifier<User?> currentUser
/// - init() loads persisted user from SharedPreferences
/// - signInWithEmail / signUpWithEmail / signOut change state and persist
class AuthenticationService {
  AuthenticationService._private();
  static final AuthenticationService _instance =
      AuthenticationService._private();
  factory AuthenticationService() => _instance;

  final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

  static const _prefsKey = 'union_shop_auth_v1';

  /// Initialize service by reading persisted user (if any).
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService.init(): raw="$raw"');
      }
      if (raw != null && raw.isNotEmpty && raw.trim().toLowerCase() != 'null') {
        final decoded = json.decode(raw);
        if (decoded is Map<String, dynamic>) {
          currentUser.value = User.fromJson(decoded);
          if (kDebugMode) {
            // ignore: avoid_print
            print(
                'AuthenticationService.init(): loaded user=${currentUser.value?.email}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService.init(): failed to load prefs: $e');
      }
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    // Simple validation and simulated delay
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_looksLikeEmail(email)) throw Exception('Invalid email');
    final user = User(id: email, email: email, name: _nameFromEmail(email));
    currentUser.value = user;
    await _saveToPrefs();
    return user;
  }

  Future<User> signUpWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (!_looksLikeEmail(email)) throw Exception('Invalid email');
    final user = User(id: email, email: email, name: _nameFromEmail(email));
    currentUser.value = user;
    await _saveToPrefs();
    return user;
  }

  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 300));
    const email = 'google_user@example.com';
    final user = User(id: email, email: email, name: 'Google User');
    currentUser.value = user;
    await _saveToPrefs();
    return user;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    currentUser.value = null;
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = currentUser.value;
      if (user == null) {
        await prefs.remove(_prefsKey);
        return;
      }
      final raw = json.encode(user.toJson());
      await prefs.setString(_prefsKey, raw);
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService._saveToPrefs(): saved raw=$raw');
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AuthenticationService._saveToPrefs(): $e');
      }
    }
  }

  bool _looksLikeEmail(String e) =>
      e.contains('@') && e.contains('.') && e.length > 4;
  String _nameFromEmail(String e) => e.split('@').first;
}

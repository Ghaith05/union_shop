// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/auth_service.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _valid =>
      _emailController.text.contains('@') &&
      _passwordController.text.length >= 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const SizedBox.shrink()),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Branded header (logo/title + subtitle) to match the provided design
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'The UNION',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4d2963),
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Sign in',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text('Choose how you\'d like to sign in',
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Sign in with Google'),
                      onPressed: _loading
                          ? null
                          : () async {
                              setState(() => _loading = true);
                              try {
                                await AuthenticationService()
                                    .signInWithGoogle();
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/account', (r) => false);
                              } catch (e) {
                                final msg = e.toString();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Sign-in failed: $msg')),
                                  );
                                }
                                if (kDebugMode) {
                                  // ignore: avoid_print
                                  print(
                                      'AuthenticationPage: Google sign-in error: $msg');
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _loading = false);
                                }
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Password'),
                      obscureText: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (!_valid || _loading)
                                ? null
                                : () async {
                                    setState(() => _loading = true);
                                    try {
                                      await AuthenticationService()
                                          .signInWithEmail(
                                              _emailController.text,
                                              _passwordController.text);
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/account', (r) => false);
                                    } catch (e) {
                                      if (!mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Sign in failed: ${e.toString()}')));
                                    } finally {
                                      if (mounted) {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  },
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Text('Sign in'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (!_valid || _loading)
                                ? null
                                : () async {
                                    setState(() => _loading = true);
                                    try {
                                      await AuthenticationService()
                                          .signUpWithEmail(
                                              _emailController.text,
                                              _passwordController.text);
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/account', (r) => false);
                                    } catch (e) {
                                      if (!mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Sign up failed: ${e.toString()}')));
                                    } finally {
                                      if (mounted) {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  },
                            child: const Text('Sign up'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

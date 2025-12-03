import 'package:flutter/material.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/widgets/navbar.dart';

class AccountDashboard extends StatefulWidget {
  static const routeName = '/account';
  const AccountDashboard({Key? key}) : super(key: key);

  @override
  State<AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<AccountDashboard> {
  final _auth = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _auth.currentUser.addListener(_onUserChanged);
  }

  void _onUserChanged() => setState(() {});

  @override
  void dispose() {
    _auth.currentUser.removeListener(_onUserChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser.value;
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Account',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    if (user == null) ...[
                      const Text('Not signed in.'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/auth'),
                        child: const Text('Sign in'),
                      )
                    ] else ...[
                      Text('Name: ${user.name ?? '-'}'),
                      const SizedBox(height: 6),
                      Text('Email: ${user.email}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          // Capture navigator synchronously to avoid using
                          // the BuildContext across the async gap.
                          final navigator = Navigator.of(context);
                          await _auth.signOut();
                          if (!mounted) {
                            return;
                          }
                          navigator.pushNamedAndRemoveUntil(
                              '/auth', (r) => false);
                        },
                        child: const Text('Log out'),
                      ),
                    ],
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

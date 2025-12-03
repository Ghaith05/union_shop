import 'package:flutter/material.dart';
import 'package:union_shop/data/auth_service.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/data/user.dart';

/// A reusable account dashboard body that can be embedded in other pages
/// (e.g. the Cart page) or used inside the standalone [AccountDashboard]
/// scaffold.
class AccountDashboardBody extends StatelessWidget {
  const AccountDashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthenticationService();
    return ValueListenableBuilder<User?>(
      valueListenable: auth.currentUser,
      builder: (ctx, User? user, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Account', style: Theme.of(context).textTheme.titleLarge),
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
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // open edit dialog
                      final result = await showDialog<bool?>(
                        context: context,
                        builder: (ctx) {
                          final nameCtl =
                              TextEditingController(text: user.name ?? '');
                          final emailCtl =
                              TextEditingController(text: user.email);
                          return AlertDialog(
                            title: const Text('Edit profile'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameCtl,
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailCtl,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await AuthenticationService().updateProfile(
                                        name: nameCtl.text.trim(),
                                        email: emailCtl.text.trim());
                                    if (ctx.mounted)
                                      Navigator.of(ctx).pop(true);
                                  } catch (e) {
                                    if (ctx.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Update failed: ${e.toString()}')));
                                    }
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                      if (result == true) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')));
                      }
                    },
                    child: const Text('Edit profile'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await auth.signOut();
                      if (!navigator.mounted) return;
                      navigator.pushNamedAndRemoveUntil('/auth', (r) => false);
                    },
                    child: const Text('Log out'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

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
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('Account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: AccountDashboardBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

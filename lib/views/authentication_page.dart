import 'package:flutter/material.dart';

/// Authentication page scaffold with two tabs: Login and Signup.
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authenticate'),
          bottom: const TabBar(
            tabs: [
              Tab(key: Key('tab_login'), text: 'Login'),
              Tab(key: Key('tab_signup'), text: 'Signup'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Login tab placeholder')), // replaced in later commits
            Center(child: Text('Signup tab placeholder')),
          ],
        ),
      ),
    );
  }
}
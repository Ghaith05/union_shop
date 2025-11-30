import 'package:flutter/material.dart';

/// Authentication page scaffold with two tabs: Login and Signup.
/// Both tabs show non-functional placeholder widgets (UI only).
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
            LoginForm(),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          TextField(
            key: Key('login_email'),
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 12),
          TextField(
            key: Key('login_password'),
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            key: Key('login_button'),
            onPressed: null,
            child: Text('Log in'),
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            TextField(
              key: Key('signup_name'),
              decoration: InputDecoration(labelText: 'Full name'),
            ),
            SizedBox(height: 12),
            TextField(
              key: Key('signup_email'),
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              key: Key('signup_password'),
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              key: Key('signup_button'),
              onPressed: null,
              child: Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}

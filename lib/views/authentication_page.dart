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

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'login_form');
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // placeholder feedback — later commit will wire to real auth
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('login_email'),
              controller: _emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('login_password'),
              controller: _passwordCtl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('login_button'),
              onPressed: _submit,
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

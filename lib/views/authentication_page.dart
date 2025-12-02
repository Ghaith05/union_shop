import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';

/// Authentication page scaffold with two tabs: Login and Signup.
/// Both tabs show non-functional placeholder widgets (UI only).
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(context, titleWidget: const Text('Authenticate')),
        // The shared AppBar doesn't include the TabBar, so we add it below the AppBar
        body: const Column(
          children: [
            // TabBar occupies a fixed height; embed it at the top of the body
            SizedBox(
              height: 48,
              child: TabBar(tabs: [
                Tab(key: Key('tab_login'), text: 'Login'),
                Tab(key: Key('tab_signup'), text: 'Signup'),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                LoginForm(),
                SignupForm(),
              ]),
            ),
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String? savedEmail = prefs.getString('email');
                String? savedPassword = prefs.getString('password');

                if (_email == savedEmail && _password == savedPassword) {
                  Navigator.pushReplacementNamed(context, '/search');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email atau password salah')),
                  );
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Belum punya akun? Daftar di sini'),
            ),
          ],
        ),
      ),
    );
  }
}

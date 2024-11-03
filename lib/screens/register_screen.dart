import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Username
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 16.0),

              // Input Email
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16.0),

              // Input Password
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 24.0),

              // Tombol Registrasi
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _registerUser();
                  }
                },
                child: Text('Registrasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    // Simpan data pengguna di shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);

    // Kembali ke halaman login setelah registrasi berhasil
    Navigator.pop(context);
  }
}

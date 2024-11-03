import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveloka Clone',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}

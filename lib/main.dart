import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas1/screen/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uas1/screen/home_page.dart';
import 'package:uas1/screen/ticket_page.dart';
import 'package:uas1/screen/signup_page.dart';
import 'package:uas1/screen/login_page.dart' as loginPage; // Gunakan 'loginPage' sebagai prefix
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAeFAObag06eOy3VN9YyxERgHnLOYZuOWI",
      appId: "1:867655212215:android:e64740950b9d84e3f70132",
      messagingSenderId: "867655212215",
      projectId: "fir-authentication-39669",
    ),
  ); // Inisialisasi Firebase
  runApp(CinebooApp());
}

class CinebooApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TicketProvider(),
      child: MaterialApp(
        title: 'CINEBOO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthPage(),
        routes: {
          '/signup': (context) => RegisterForm(),
          '/login': (context) => loginPage.LoginForm(),
          '/home': (context) => HomePage(email: ''), // Email parameter akan diisi saat navigasi
        },
      ),
    );
  }
}

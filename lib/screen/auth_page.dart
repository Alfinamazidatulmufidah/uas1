import 'package:flutter/material.dart';
import 'package:uas1/screen/signup_page.dart';
import 'login_page.dart';  // Import halaman login
import 'signup_page.dart';  // Import halaman register

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image.asset('assets/CINEBOO.png', height: 100),
              const SizedBox(height: 50),
              TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Masuk'),
                  Tab(text: 'Daftar'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    LoginForm(),
                    RegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

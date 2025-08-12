import 'package:flutter/material.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea), 
              Color(0xFF00B4DB),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AuthForm(
              onSubmit: (email, password, isLogin, username) {
                if (isLogin) {
                  print("Giriş: Email: $email, Password: $password");
                } else {
                  print(
                    "Kayıt: Email: $email, Username: $username, Password: $password",
                  );
                }
                // Buradan Firebase auth işlemlerini yapabilirim
              },
            ),
          ),
        ),
      ),
    );
  }
}

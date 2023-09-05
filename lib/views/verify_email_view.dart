import 'package:flutter/material.dart';
import 'package:flutterbegin1/constants/routes.dart';
import 'package:flutterbegin1/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verify"),
        backgroundColor: const Color.fromARGB(214, 18, 120, 222),
        titleTextStyle:
            TextStyle(color: Color.fromARGB(255, 239, 239, 239), fontSize: 20),
      ),
      body: Column(
        children: [
          const Text(
              "We've send you an email verification. Please open it to verify account"),
          const Text(
              "If you haven't received a verification email yet, please press the button below"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}

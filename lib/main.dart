import 'package:flutter/material.dart';
import 'package:flutterbegin1/constants/routes.dart';
import 'package:flutterbegin1/services/auth/auth_service.dart';
//Views
import 'package:flutterbegin1/views/login_view.dart';
import 'package:flutterbegin1/views/notes/create_update_note_view.dart';
import 'package:flutterbegin1/views/notes/notes_view.dart';
import 'package:flutterbegin1/views/register_view.dart';
import 'package:flutterbegin1/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoutes: (context) => const NotesView(),
      verifyEmailRoutes: (context) => const VerifyEmailView(),
      createUpdateNoteRoute: (context) => const CreateUpateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

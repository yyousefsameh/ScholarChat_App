import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //يعني جيب نظام التشغيل ال شغال عليه يعني شغال علي ios جيبه شغال علي android وهكذا
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChatApp());
}

class ScholarChatApp extends StatelessWidget {
  const ScholarChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginScreen.loginScreenId: (context) => const LoginScreen(),
        RegisterScreen.registerScreenId: (context) => const RegisterScreen(),
        ChatScreen.chatScreenId: (context) => ChatScreen(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.loginScreenId,
    );
  }
}

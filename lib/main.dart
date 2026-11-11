import 'package:flutter/material.dart';
import 'pages/login_pages.dart';
import 'services/app_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage().ensureDefaultUser();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        onLogin: () {
          
        },
      ),
    )
  );
}
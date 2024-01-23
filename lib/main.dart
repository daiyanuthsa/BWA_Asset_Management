import 'package:bwa_asset_management/pages/user/pages_login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                primary: Colors.purple,
                secondary: Colors.amber),
            scaffoldBackgroundColor: Colors.purple[50],
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 40,
              )),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              backgroundColor: const MaterialStatePropertyAll(Colors.purple),
            ))),
        home: LoginPage());
  }
}

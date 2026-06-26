import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Solo orientación vertical para mejor legibilidad del QR
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const QrAccesoApp());
}

class QrAccesoApp extends StatelessWidget {
  const QrAccesoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acceso SENA',
      debugShowCheckedModeBanner: false,
      theme: senaTheme(),
      home: const LoginScreen(),
    );
  }
}
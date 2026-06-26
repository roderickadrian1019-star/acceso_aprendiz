import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_screen.dart';

class ExpiredScreen extends StatelessWidget {
  final String nombre;

  const ExpiredScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_clock_outlined,
                    size: 52,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Código expirado',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'El código QR de $nombre ha vencido.\nPor seguridad, genera uno nuevo para ingresar.',
                  style: const TextStyle(
                    fontSize: 15,
                    color: SenaColors.grisTexto,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Generar nuevo código'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
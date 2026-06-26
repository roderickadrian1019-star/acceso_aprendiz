import 'package:flutter/material.dart';
import '../theme.dart';
import 'qr_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _documentoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _generarQr() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrScreen(
            nombre: _nombreController.text.trim(),
            documento: _documentoController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Logo / ícono SENA
                  Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: SenaColors.verde,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  Text(
                    'Acceso a sede',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa tus datos para generar el código QR',
                    style: TextStyle(fontSize: 15, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  TextFormField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingresa tu nombre';
                      if (v.trim().length < 3) return 'El nombre es muy corto';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _documentoController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    decoration: const InputDecoration(
                      labelText: 'Número de documento',
                      prefixIcon: Icon(Icons.badge_outlined),
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingresa tu número de documento';
                      if (v.trim().length < 6) return 'El documento debe tener al menos 6 dígitos';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  FilledButton.icon(
                    onPressed: _generarQr,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Generar código QR'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
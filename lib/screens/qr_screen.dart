import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../widgets/countdown_timer.dart';
import 'expired_screen.dart';

class QrScreen extends StatefulWidget {
  final String nombre;
  final String documento;

  const QrScreen({
    super.key,
    required this.nombre,
    required this.documento,
  });

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  bool _qrVisible = true;

  String get _qrData => 'SENA|${widget.nombre}|${widget.documento}';

  void _onExpired() {
    setState(() => _qrVisible = false);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ExpiredScreen(nombre: widget.nombre),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = size.width * 0.85;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: SenaColors.verdeClaro,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SenaColors.verde.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.nombre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: SenaColors.grisOscuro,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Documento: ${widget.documento}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: SenaColors.grisTexto,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                AnimatedOpacity(
                  opacity: _qrVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: QrImageView(
                      data: _qrData,
                      version: QrVersions.auto,
                      size: qrSize - 32,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: SenaColors.verdeOscuro,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: SenaColors.grisOscuro,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                CountdownTimer(
                  seconds: 60,
                  onExpired: _onExpired,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Muestra este código al ingresar a la sede',
                  style: TextStyle(fontSize: 13, color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
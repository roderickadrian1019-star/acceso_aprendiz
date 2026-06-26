import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null) return;

    setState(() => _scanned = true);
    _controller.stop();
    final parts = raw.split('|');
    final esFormatoSena = parts.length == 3 && parts[0] == 'SENA';

    _mostrarResultado(raw, esFormatoSena ? parts : null);
  }

  void _mostrarResultado(String rawValue, List<String>? partes) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ResultadoSheet(
        rawValue: rawValue,
        partes: partes,
        onCerrar: () {
          Navigator.pop(context); // cierra sheet
          Navigator.pop(context); // vuelve al login
        },
        onReintentar: () {
          Navigator.pop(context); // cierra sheet
          setState(() => _scanned = false);
          _controller.start();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear código QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_off : Icons.flash_on),
            onPressed: () {
              setState(() => _torchOn = !_torchOn);
              _controller.toggleTorch();
            },
            tooltip: _torchOn ? 'Apagar linterna' : 'Encender linterna',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          _ScanOverlay(),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Icon(Icons.qr_code_scanner, color: Colors.white70, size: 28),
                const SizedBox(height: 8),
                const Text(
                  'Apunta la cámara al código QR del aprendiz',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const ventana = 260.0;
    final top = (size.height - ventana) / 2 - 40;
    final left = (size.width - ventana) / 2;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _OverlayPainter(
              ventanaRect: Rect.fromLTWH(left, top, ventana, ventana),
            ),
          ),
        ),
        Positioned(
          left: left,
          top: top,
          child: _Esquinas(size: ventana),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: top - 36,
          child: const Text(
            'Código QR SENA',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect ventanaRect;
  _OverlayPainter({required this.ventanaRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.65);
    final full = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(full)
      ..addRRect(RRect.fromRectAndRadius(ventanaRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_OverlayPainter old) => old.ventanaRect != ventanaRect;
}

class _Esquinas extends StatelessWidget {
  final double size;
  const _Esquinas({required this.size});

  @override
  Widget build(BuildContext context) {
    const len = 24.0;
    const stroke = 3.0;
    final color = SenaColors.verde;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EsquinasPainter(color: color, len: len, stroke: stroke),
      ),
    );
  }
}

class _EsquinasPainter extends CustomPainter {
  final Color color;
  final double len, stroke;
  _EsquinasPainter({required this.color, required this.len, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final w = size.width;
    final h = size.height;
    canvas.drawLine(Offset(0, len), Offset(0, 0), p);
    canvas.drawLine(Offset(0, 0), Offset(len, 0), p);
    canvas.drawLine(Offset(w - len, 0), Offset(w, 0), p);
    canvas.drawLine(Offset(w, 0), Offset(w, len), p);
    canvas.drawLine(Offset(0, h - len), Offset(0, h), p);
    canvas.drawLine(Offset(0, h), Offset(len, h), p);
    canvas.drawLine(Offset(w - len, h), Offset(w, h), p);
    canvas.drawLine(Offset(w, h), Offset(w, h - len), p);
  }

  @override
  bool shouldRepaint(_EsquinasPainter old) => false;
}
class _ResultadoSheet extends StatelessWidget {
  final String rawValue;
  final List<String>? partes; 
  final VoidCallback onCerrar;
  final VoidCallback onReintentar;

  const _ResultadoSheet({
    required this.rawValue,
    required this.partes,
    required this.onCerrar,
    required this.onReintentar,
  });

  bool get _valido => partes != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _valido ? SenaColors.verdeClaro : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _valido ? Icons.check_circle_outline : Icons.error_outline,
              color: _valido ? SenaColors.verde : Colors.red,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            _valido ? 'Código válido' : 'Código no reconocido',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _valido ? SenaColors.grisOscuro : Colors.red,
            ),
          ),
          const SizedBox(height: 20),

          if (_valido) ...[
            _DataRow(label: 'Nombre', value: partes![1]),
            const SizedBox(height: 10),
            _DataRow(label: 'Documento', value: partes![2]),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rawValue,
                style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este código no pertenece al sistema SENA.',
              style: TextStyle(fontSize: 13, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReintentar,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: SenaColors.verde),
                    foregroundColor: SenaColors.verde,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Escanear otro'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onCerrar,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: SenaColors.verde,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Listo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SenaColors.verdeClaro,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SenaColors.verde.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              color: SenaColors.grisTexto,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: SenaColors.grisOscuro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
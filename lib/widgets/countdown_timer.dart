import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;

  final VoidCallback onExpired;

  const CountdownTimer({
    super.key,
    this.seconds = 60,
    required this.onExpired,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late int _remaining;
  late AnimationController _progressController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (_remaining <= 1) {
      timer.cancel();
      setState(() => _remaining = 0);
      widget.onExpired();
    } else {
      setState(() => _remaining--);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  Color get _color {
    if (_remaining > 30) return Colors.green;
    if (_remaining > 10) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 1 - _progressController.value,
                    strokeWidth: 6,
                    backgroundColor: Colors.black12,
                    color: _color,
                    strokeCap: StrokeCap.round,
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: _remaining <= 10 ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: _color,
                    ),
                    child: Text('$_remaining'),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _remaining > 0 ? 'El código expira en $_remaining s' : '¡Código expirado!',
          style: TextStyle(
            fontSize: 13,
            color: _color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
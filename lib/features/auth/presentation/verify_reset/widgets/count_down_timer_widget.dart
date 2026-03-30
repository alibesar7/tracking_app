import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onTimerEnd;
  final Color? activeColor;
  final Color? inactiveColor;

  const CountdownTimerWidget({
    super.key,
    required this.initialSeconds,
    required this.onTimerEnd,
    this.activeColor = Colors.pink,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        widget.onTimerEnd();
      }
    });
  }

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _remainingSeconds > 0;

    return Text(
      isActive ? _formatTime() : '00:00',
      style: (Theme.of(context).textTheme.bodyMedium)?.copyWith(
        color: isActive ? widget.activeColor : widget.inactiveColor,
      ),
    );
  }
}

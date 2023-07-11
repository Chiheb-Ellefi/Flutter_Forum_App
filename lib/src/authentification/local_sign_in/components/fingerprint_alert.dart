import 'package:flutter/material.dart';

class FingerPrintAlert extends StatefulWidget {
  const FingerPrintAlert({super.key});

  @override
  State<FingerPrintAlert> createState() => _FingerPrintAlertState();
}

class _FingerPrintAlertState extends State<FingerPrintAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Confirm your fingerprint')),
      content: Image.asset(
        'assets/fingerprint.png',
        width: 120,
        height: 120,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Text('Please touch the fingerprint sensor',
                  style: TextStyle(fontSize: 18, fontFamily: 'Inter'))),
        )
      ],
    );
  }
}

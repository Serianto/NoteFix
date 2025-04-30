import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoNotes extends StatelessWidget {
  const NoNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('Assets/lottiehello.json'),
            const SizedBox(height: 32,), 
            const Text('Kamu tidak memiliki note disini',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              //fontFamily: 'Fredoka',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),);
  }
}
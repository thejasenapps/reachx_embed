import 'package:flutter/material.dart';

class FlagWavingGif extends StatefulWidget {
  const FlagWavingGif({super.key});

  @override
  State<FlagWavingGif> createState() => _FlagWavingGifState();
}

class _FlagWavingGifState extends State<FlagWavingGif> {
  final Key _gifKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Image.asset(
        'lib/assets/gif/flag_waving1.gif',
        key: _gifKey,
        height: 120,
        gaplessPlayback: true,
      ),
    );
  }
}


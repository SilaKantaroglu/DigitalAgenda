import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import '../menu/menu.dart';

class HosgeldinizSayfasi extends StatefulWidget {
  const HosgeldinizSayfasi({Key? key}) : super(key: key);

  @override
  HosgeldinizSayfasiState createState() => HosgeldinizSayfasiState();
}

class HosgeldinizSayfasiState extends State<HosgeldinizSayfasi> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 500),
          tag: 'opacity',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(milliseconds: 500),
          to: const Duration(milliseconds: 1000),
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 360),
          from: const Duration(milliseconds: 1000),
          to: const Duration(milliseconds: 2000),
          tag: 'rotation',
        )
        .animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuSayfasi()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 119, 49, 132),
              Colors.purple[400]!,
              Colors.pink[300]!,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _sequenceAnimation['scale'].value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Center(
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation(_sequenceAnimation['rotation'].value / 360),
                            child: Icon(
                              Icons.fingerprint,
                              size: 150,
                              color: Colors.pink[300],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: _sequenceAnimation['opacity'].value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

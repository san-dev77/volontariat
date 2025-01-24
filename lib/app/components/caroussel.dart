import 'package:flutter/material.dart';
import 'dart:async';

class CarouselCard extends StatefulWidget {
  final Widget card1;
  final Widget card2;
  final Duration duration;

  const CarouselCard({
    required this.card1,
    required this.card2,
    this.duration = const Duration(seconds: 5), // Durée entre les échanges
    Key? key,
  }) : super(key: key);

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationCard1;
  late Animation<Offset> _animationCard2;
  bool _showFirst = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _animationCard1 = Tween<Offset>(
      begin: Offset(0, 0), // Position de départ
      end: Offset(-1, 0), // Déplacement vers la gauche
    ).animate(_controller);

    _animationCard2 = Tween<Offset>(
      begin: Offset(1, 0), // Position de départ hors écran
      end: Offset(0, 0), // Arrive au centre
    ).animate(_controller);

    // Démarrer le timer pour l'échange automatique
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.duration, (timer) {
      _swapCards();
    });
  }

  void _swapCards() {
    setState(() {
      if (_showFirst) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _showFirst = !_showFirst;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _animationCard1,
          child: widget.card1,
        ),
        SlideTransition(
          position: _animationCard2,
          child: widget.card2,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

abstract class AnimationController {
  final String name;
  const AnimationController(this.name);

  void animateToTop() => print('onTop');
  void animateToBottom() => print('onBottom');
  void animateToMiddle() => print('onMiddle');
}

class CardAnimation extends AnimationController {
  CardAnimation(String name) : super(name);

  @override
  void animateToBottom() {
    print('onBottom 1');
  }
}

class MainController {
  final List<CardAnimation> cards;
  const MainController(this.cards);
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  MainController mainController = MainController(
    [
      CardAnimation('1'),
      CardAnimation('2'),
      CardAnimation('3'),
    ],
  );

  CardAnimation? active;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    active = mainController.cards.first;
  }

  void _next() {
    if (activeIndex < mainController.cards.length - 1) {
      activeIndex++;
      active = mainController.cards[activeIndex];
      active!.animateToTop();
      mainController.cards[activeIndex - 1].animateToBottom();
    }
  }

  void _previous() {}

  @override
  Widget build(BuildContext context) {
    mainController.cards[0].animateToBottom();
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _next,
                child: const Text('Next'),
              ),
              ElevatedButton(
                onPressed: _previous,
                child: const Text('Previous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

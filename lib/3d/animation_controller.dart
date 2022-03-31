import 'package:flutter/material.dart';

abstract class CardAnimationController {
  const CardAnimationController();

  void animateBottomToMiddle() {}
  void animateMiddleToBottom() {}
  void animateMiddleToTop() {}
  void animateTopToMiddle() {}
}

abstract class ItemsController {
  final List<Widget> children;
  const ItemsController(this.children);

  void nextItem() {}
  void previousItem() {}
}

import 'package:credit_cards/widget/credit_card_animation_model.dart';
import 'package:credit_cards/widget/credit_card_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CreditCards3d extends StatefulWidget {
  final List<CreditCardItem> children;
  final Function(LinearGradient?) onSelected;
  const CreditCards3d({
    required this.children,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<CreditCards3d> createState() => _CreditCards3dState();
}

class _CreditCards3dState extends State<CreditCards3d> {
  double dxLight = 1.0;
  double dyLight = 0.0;
  List<CreditCardItem>? _cards;
  List<CardAnimationController> _items = [];

  List<CardAnimationController> _topCards = [];
  int? _selectedCardIndex;

  @override
  void initState() {
    super.initState();
    _cards = widget.children;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCards();
  }

  void _onTop(int index) {
    setState(() {
      print('_cards - ${_cards!.length}');
      if (_items.length == widget.children.length) {
        // print(
        // '${_items[0].item.cardInfo.index} ${_items[1].item.cardInfo.index} ${_items[2].item.cardInfo.index} ${_items[3].item.cardInfo.index}');
        final elIndex = _items
            .indexWhere((element) => element.item.cardInfo.index == index);
        _topCards.add(_items[elIndex]);
        if (elIndex != _items.length - 1) {
          _items.insert(_items.length - 1, _items.removeAt(elIndex));
        }
      }
    });
  }

  // void _onBottom(int index) {
  //   setState(() {
  //     if (_cards != null) {
  //       final elIndex =
  //           _cards!.indexWhere((element) => element.cardInfo.index == index);
  //       _topCards.removeLast();
  //       if (elIndex != _cards!.length - 1) {
  //         _cards!.insert(_cards!.length - 1, _cards!.removeAt(elIndex));
  //       }
  //     }
  //   });
  // }

  void _onSelected(int? index) {
    setState(() {
      _selectedCardIndex = index;
      if (index != null) {
        widget.onSelected(widget.children[index].cardInfo.gradient!);
      } else {
        widget.onSelected(null);
      }
      // _updateDraggable(selected);
    });
  }

  void _initCards() {
    setState(() {
      for (var i = 0; i < widget.children.length; i++) {
        _items.add(
          CardAnimationController(
            activeIndex: _selectedCardIndex ?? 0,
            key: UniqueKey(),
            item: _cards![i],
            data: CardAnimationModel(
              x: 10 + i * 15,
              y: 100,
              dxLight: 0,
              dyLight: 0,
            ),
            onTop: _onTop,
            onSelected: _onSelected,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: _items,
        ),
      ),
    );
  }
}

class CardAnimationController extends StatefulWidget {
  final CreditCardItem item;
  final CardAnimationModel data;
  final int activeIndex;
  final Function(int) onTop;
  final Function(int?) onSelected;

  const CardAnimationController({
    required this.activeIndex,
    required this.onSelected,
    required this.onTop,
    required this.item,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<CardAnimationController> createState() =>
      _CardAnimationControllerState();
}

class _CardAnimationControllerState extends State<CardAnimationController>
    with SingleTickerProviderStateMixin {
  double perspectiveStart = -0.002;
  double perspectiveEnd = 0.000;

  double yStart = 0.5;
  double yEnd = 1.0;

  double xStart = 0;
  double xCenter = -150;
  double xEnd = -180;

  double zStart = 1;
  double zCenter = 0.9;
  double zEnd = 1.3;

  double animationStart = 1.0;
  double animationCenter = 2.0;
  double animationEnd = 3.0;

  double controllerStart = 0.0;
  double controllerCenter = 0.5;
  double controllerEnd = 1.0;

  bool _active = false;

  /// Control animation steps 0 [controllerStart] -> 0.5 [controllerCenter]-> 1[controllerEnd]
  AnimationController? animationController;

  /// Main animations values 1 [animationStart] -> 2 [animationCenter] -> 3 [animationEnd]
  Animation? animation;

  @override
  void initState() {
    super.initState();
    animationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animation = Tween(begin: animationStart, end: animationEnd)
        .animate(animationController!);

    animationController?.addListener(() {
      if (animation != null) {
        if (animation!.value >= 1.2) {
          print(widget.activeIndex);
          widget.onTop(widget.item.cardInfo.index);
        }
        if (animation!.value >= 1.2) {
          widget.onSelected(widget.item.cardInfo.index);
        }
        if (animation!.value >= 2.4 || animation!.value < 1.2) {
          widget.onSelected(null);
        }
      }
    });

    _checkPosition;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _checkPosition() {
    setState(() {
      if (widget.activeIndex == widget.item.cardInfo.index) {
        _animateBottomToCenter();
      }
    });
  }

  /// Move [widget.item] From Bottom to Center
  void _animateBottomToCenter() {
    animationController?.animateTo(controllerCenter);
  }

  /// Move [widget.item] From Center to Bottom if user swipe to Bottom
  void _animateCenterToBottom() {
    animationController?.reverse();
  }

  /// Move [widget.item] From End to Center
  void _animateEndToCenter() {
    animationController?.animateTo(controllerCenter);
  }

  /// Move [widget.item] From Center to End if user swipe to Top
  void _animateCenterToEnd() {
    animationController?.forward();
  }

  /// Dependence X [xStart], Y [yStart], Z [zStart], P [perspectiveStart] on T [animation]
  /// Where T [animation] can be [1,2,3]

  /// 1 -> 0 [xStart]; 2 -> -150 [xCenter]; 3 -> -180 [xEnd]
  double _calcX() {
    double? t = animation?.value;
    t ??= 1;
    return 60 * (t * t) - 330 * t + 270;
  }

  /// 1 -> 0.5 [yStart]; 2 -> 1 [yEnd]; 3 -> 1 [yEnd]
  double _calcY() {
    double? t = animation?.value;
    t ??= 1;
    if (t >= 2) return 1;
    return -0.25 * (t * t) + 1.25 * t - 0.5;
    // return -0.8076923 / t + 1.3269231;
  }

  /// 1 -> 1 [zStart]; 2 -> 0.9 [zCenter]; 3 -> 1.2 [zEnd]
  double _calcZ() {
    double? t = animation?.value;
    t ??= 1;
    return 0.2 * (t * t) - 0.7 * t + 1.5;
  }

  /// 1 -> -0.002 [perspectiveStart]; 2 -> 0 [perspectiveEnd]; 3 -> 0 [perspectiveEnd]
  double _calcP() {
    double? t = animation?.value;
    t ??= 1;
    if (t >= 2) return 0;
    return -0.001 * (t * t) + 0.005 * t - 0.006;
  }

  double _calcShadow() {
    double? t = animation?.value;
    t ??= 1;
    return -32 * t * t + 128 * t - 88;
  }

  void _determineDircetion(DragUpdateDetails details) {
    if (animation?.value == animationStart) {
      _animateBottomToCenter();
    } else if (animation?.value == animationCenter) {
      if (details.delta.direction < 0) {
        _animateCenterToEnd();
      } else {
        _animateCenterToBottom();
      }
    } else if (animation?.value == animationEnd) {
      _animateEndToCenter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.data.x,
      left: MediaQuery.of(context).size.width / 2 -
          widget.item.cardInfo.width / 2,
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, _) {
          return Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4(
              //
              1, 0, 0, 0,
              0, _calcY(), 0, _calcP(),
              0, 0, 1, 0,
              0, _calcX(), 0, _calcZ(),
              //
            ),
            child: GestureDetector(
              onPanEnd: (details) {},
              onPanUpdate: _determineDircetion,
              child: Neumorphic(
                style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
                  depth: _calcShadow(),
                  intensity: 1,
                  lightSource: LightSource(
                    widget.data.dxLight,
                    widget.data.dyLight,
                  ),
                ),
                child: widget.item,
              ),
            ),
          );
        },
      ),
    );
  }
}

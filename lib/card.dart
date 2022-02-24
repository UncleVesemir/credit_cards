import 'package:credit_cards/const.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  List<CreditCard> _cards = [];
  List<bool> _draggableCards = [false, false, false, true];
  List<CreditCard> _topCards = [];

  int? _selectedCardIndex = null;

  void _onTop(int index) {
    setState(() {
      final elIndex = _cards.indexWhere((element) => element.index == index);
      _topCards.add(_cards[elIndex]);
      if (elIndex != _cards.length - 1) {
        _cards.insert(_cards.length - 1, _cards.removeAt(elIndex));
      }
    });
  }

  void _onBottom(int index) {
    setState(() {
      final elIndex = _cards.indexWhere((element) => element.index == index);
      _topCards.removeLast();
      if (elIndex != _cards.length - 1) {
        _cards.insert(_cards.length - 1, _cards.removeAt(elIndex));
      }
    });
  }

  void _onSelected(int? selected) {
    setState(() {
      _selectedCardIndex = selected;
      _updateDraggable(selected);
    });
  }

  bool _isDraggable(int index) {
    setState(() {});
    if (_cards.length == 4) {
      final elIndex = _cards.indexWhere((element) => element.index == index);
      return _draggableCards[elIndex];
    }
    return _draggableCards[index];
  }

  void _updateDraggable(int? selected) {
    setState(() {
      if (selected != null) {
        // print('not null $selected');
        final elIndex =
            _cards.indexWhere((element) => element.index == selected);
        for (var el in _cards) {
          el.draggable = false;
        }
        _cards[elIndex].draggable = true;
      }
      if (selected == null) {
        // print(selected ?? 'null');

        final elIndex =
            _cards.indexWhere((element) => element.draggable == true);
        for (var el in _cards) {
          el.draggable = true;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cards.add(CreditCard(
      key: UniqueKey(),
      gradient: AppColors.corallGradient,
      start: 540,
      end: 280,
      onTop: _onTop,
      onBottom: _onBottom,
      onSelected: _onSelected,
      index: 0,
      draggable: false,
      transparent: false,
    ));
    _cards.add(CreditCard(
      key: UniqueKey(),
      gradient: AppColors.violetGradient,
      start: 520,
      end: 260,
      onTop: _onTop,
      onBottom: _onBottom,
      onSelected: _onSelected,
      index: 1,
      draggable: false,
      transparent: false,
    ));
    _cards.add(CreditCard(
      key: UniqueKey(),
      gradient: AppColors.deepOrangeGradient,
      start: 500,
      end: 240,
      onTop: _onTop,
      onBottom: _onBottom,
      onSelected: _onSelected,
      index: 2,
      draggable: false,
      transparent: false,
    ));
    _cards.add(CreditCard(
      key: UniqueKey(),
      gradient: AppColors.amberGradient,
      start: 480,
      end: 220,
      onTop: _onTop,
      onBottom: _onBottom,
      onSelected: _onSelected,
      index: 3,
      draggable: true,
      transparent: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedCardIndex != null
              ? _cards[_cards.indexWhere(
                      (element) => element.index == _selectedCardIndex)]
                  .gradient
              : null,
          color: HexColor('#fbe9e7'),
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: _cards,
          ),
        ),
      ),
    );
  }
}

class CreditCard extends StatefulWidget {
  final int index;
  final LinearGradient gradient;
  final double start;
  final double end;
  final Function(int) onTop;
  final Function(int) onBottom;
  final Function(int?) onSelected;
  bool draggable;
  bool transparent;
  CreditCard({
    required this.index,
    required this.gradient,
    required this.start,
    required this.end,
    required this.onBottom,
    required this.onTop,
    required this.onSelected,
    required this.draggable,
    required this.transparent,
    Key? key,
  }) : super(key: key);

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  Widget _card() {
    return Image.asset('assets/images/card.png');
  }

  bool active = false;

  double x = 0;
  double y = 0;
  double startY = 0.8;
  double yStep = 0.01;
  double z = 0;

  double distance = 1;
  double minDistance = 1;
  double maxDistance = 1.35;
  double distanceStep = 0.01;

  double bottom = -1.1;
  // double centre = -3.1;
  double centre = -2.6;
  double end = -3.1;

  bool _onTop = false;
  bool _onBottom = true;

  double perspective = -0.0003;
  double minPerspective = -0.0003;
  double maxPerspective = 0.0;
  double perspectiveStep = 0.00003;

  // TODO
  double dragSensitivity = -60;

  double _calcTop() {
    if (x == 0) return widget.start;
    if (x > 0) return widget.start;
    // if (x < widget.end) return widget.end;
    return widget.start + -x * dragSensitivity;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.key);
    return Positioned(
      left: 35,
      top: _calcTop(),
      child: Transform(
        transform: Matrix4(
          //
          1, 0, 0, 0,
          0, startY, 0, perspective * 5,
          0, 0, 1, 0,
          0, 0, 0, distance,
        )..setEntry(3, 2, 0.001),
        // ..rotateX(x)
        // ..rotateY(y)
        // ..rotateZ(z),
        alignment: FractionalOffset.center,
        child: GestureDetector(
          // WHEN USER RELEASE FINGER FROM SCREEN
          onPanEnd: (details) {
            setState(() {
              if (widget.draggable) {
                // 0 < X > BOTTOM
                if (x > bottom) {
                  x = 0;
                  perspective = minPerspective;
                  widget.onSelected(null);
                  distance = minDistance;
                  startY = 0.8;
                }
                // BOTTOM < X > CENTER
                if (x < bottom && x > centre) {
                  x = centre;
                  perspective = maxPerspective;
                  widget.onSelected(widget.index);
                  distance = minDistance;
                  startY = 1;
                }
                // X > CENTER
                if (x < centre) {
                  x = end;
                  perspective = maxPerspective;
                  widget.onSelected(null);
                  distance = maxDistance;
                  startY = 1;
                }
              }
            });
          },
          onPanUpdate: (details) {
            if (widget.draggable) {
              // print('x - $x');
              // print('perspective - $perspective');
              setState(() {
                // BOTTOM TO CENTER
                if (x < bottom + 0.5 &&
                    perspective < maxPerspective &&
                    details.delta.dy < 0) {
                  if (startY + yStep >= 1) {
                    startY = 1;
                  } else {
                    startY += yStep;
                  }
                  if (perspective + perspectiveStep >= maxPerspective) {
                    perspective = maxPerspective;
                  } else {
                    perspective += perspectiveStep;
                    startY += yStep;
                  }
                } else if (x > bottom + 0.5 &&
                    perspective > minPerspective &&
                    details.delta.dy > 0) {
                  if (startY - yStep <= 0.8) {
                    startY = 0.8;
                  } else {
                    startY -= yStep;
                  }
                  if (perspective - perspectiveStep <= minPerspective) {
                    perspective = minPerspective;
                  } else {
                    perspective -= perspectiveStep;
                    startY -= yStep;
                  }
                }
                //

                if (x < centre + 2.4 && !_onTop && details.delta.dy < 0) {
                  _onTop = true;
                  _onBottom = false;
                  widget.onTop(widget.index);
                }

                if (x > end && !_onBottom && details.delta.dy > 0) {
                  _onBottom = true;
                  _onTop = false;
                  widget.onBottom(widget.index);
                }
                // if (x < centre) widget.onTop;

                // CENTER TO END
                // print('distance - $distance');
                if (x < centre &&
                    details.delta.dy < 0 &&
                    distance <= maxDistance) {
                  if (distance + distanceStep >= maxDistance) {
                    distance = maxDistance;
                  } else {
                    distance += distanceStep;
                  }
                } else if (x > centre &&
                    details.delta.dy > 0 &&
                    distance >= minDistance) {
                  if (distance - distanceStep <= minDistance) {
                    distance = minDistance;
                  } else {
                    distance -= distanceStep;
                  }
                }
                //

                // IS ACTIVE ?
                if (x < bottom && x > centre) {
                  widget.onSelected(widget.index);
                  active = true;
                } else {
                  widget.onSelected(null);
                  active = false;
                }
                //

                // GESTURES (DX/DY)

                // DY CALC
                y = y - details.delta.dx / 100;
                //

                // DX CALC LIMITS
                if (x <= 0) {
                  if (x + details.delta.dy / 100 > 0) {
                    x = 0;
                  } else if (x + details.delta.dy / 100 <= end) {
                    x = end;
                  } else {
                    x = x + details.delta.dy / 100;
                  }
                  //
                }
              });
              //
            }
          },
          child: Opacity(
            opacity: widget.transparent ? 0.4 : 1,
            child: SizedBox(
              height: 190.0,
              width: 300.0,
              child: Card(
                elevation: active ? 40 : 20,
                shadowColor: active ? Colors.black : Colors.black26,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: active ? 3 : 1,
                    color: active
                        ? Colors.black.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, bottom: 18, right: 24),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  '2182',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                Text(
                                  'ILYA LEBEDZEU ${widget.index}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 40,
                                width: 80,
                                child: Image.asset(
                                  'assets/images/mastercard.png',
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

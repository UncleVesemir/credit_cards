import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  List<CreditCard> _cards = [];
  List<int> _cardsIndexes = [0, 1, 2, 3];

  // void _onTop(int index) {
  //   print('onTop');
  //   setState(() {
  //     if (_cardsIndexes.indexOf(index) > 0 &&
  //         _cardsIndexes.indexOf(index) != _cardsIndexes.length - 1) {
  //       _cardsIndexes.insert(index, _cardsIndexes.removeAt(index));
  //     }
  //     print('onTop - $_cardsIndexes');
  //   });
  // }

  // void _onBottom(int index) {
  //   setState(() {
  //     if (_cardsIndexes.indexOf(index) > 0 &&
  //         _cardsIndexes.indexOf(index) != _cardsIndexes.length - 1) {
  //       _cardsIndexes.insert(index + 1, _cardsIndexes.removeAt(index));
  //     }
  //   });
  //   print('onBottom - $_cardsIndexes');
  // }

  void _onTop(int index) {
    print('onTop');
    setState(() {
      final elIndex = _cards.indexWhere((element) => element.index == index);
      _cards.insert(_cards.length - 1, _cards.removeAt(elIndex));

      _cards.forEach((element) {
        print('onTop - ${element.index} and ${element.start}');
      });
    });
  }

  void _onBottom(int index) {
    setState(() {
      final elIndex = _cards.indexWhere((element) => element.index == index);
      _cards.insert(_cards.length - 1, _cards.removeAt(elIndex));
    });
    _cards.forEach((element) {
      print('onBottom - ${element.index} and ${element.start}');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cards.add(CreditCard(
      color: HexColor('#ffebee'),
      start: 530,
      end: 280,
      onTop: _onTop,
      onBottom: _onBottom,
      index: 0,
    ));
    _cards.add(CreditCard(
      color: HexColor('#f1f8e9'),
      start: 510,
      end: 260,
      onTop: _onTop,
      onBottom: _onBottom,
      index: 1,
    ));
    _cards.add(CreditCard(
      color: HexColor('#e3f2fd'),
      start: 490,
      end: 240,
      onTop: _onTop,
      onBottom: _onBottom,
      index: 2,
    ));
    _cards.add(CreditCard(
      color: HexColor('#fbe9e7'),
      start: 470,
      end: 220,
      onTop: _onTop,
      onBottom: _onBottom,
      index: 3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#ede7f6'),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: _cards,
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   print('REBUILDED');
  //   return Scaffold(
  //     body: Container(
  //       color: HexColor('#ede7f6'),
  //       child: Center(
  //         child: Indexer(
  //           children: [
  //             for (var i = 0; i < _cards.length; i++)
  //               Indexed(
  //                 child: _cards[i],
  //                 key: _cards[i].key,
  //                 index: _cardsIndexes.indexOf(i),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}

class CreditCard extends StatefulWidget {
  final int index;
  final Color color;
  final double start;
  final double end;
  final Function(int) onTop;
  final Function(int) onBottom;
  const CreditCard({
    required this.index,
    required this.color,
    required this.start,
    required this.end,
    required this.onBottom,
    required this.onTop,
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
  double z = 0;

  double distance = 1;
  double minDistance = 1;
  double maxDistance = 1.25;
  double distanceStep = 0.02;

  double bottom = -1.4;
  double centre = -3.1;
  double end = -4.50;

  bool _onTop = false;
  bool _onBottom = true;

  double perspective = -0.00015;
  double minPerspective = -0.00015;
  double maxPerspective = 0.0;
  double perspectiveStep = 0.00001;

  double _calcTop() {
    if (x == 0) return widget.start;
    if (x > 0) return widget.start;
    // if (x < widget.end) return widget.end;
    return widget.start + -x * -60;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.key);
    return Positioned(
      left: 35,
      top: _calcTop(),
      child: Transform(
        transform: Matrix4(1, 0, 0, 0, 0, 1, 0, perspective * 5, 0, 0, 1, 0, 0,
            0, 0, distance),
        // ..rotateX(x)
        // ..rotateY(y)
        // ..rotateZ(z),
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onPanUpdate: (details) {
            // print('x - $x');
            // print('perspective - $perspective');
            setState(() {
              // BOTTOM TO CENTER
              if (x < bottom &&
                  perspective < maxPerspective &&
                  details.delta.dy < 0) {
                if (perspective + perspectiveStep >= maxPerspective) {
                  perspective = maxPerspective;
                } else {
                  perspective += perspectiveStep;
                }
              } else if (x > bottom &&
                  perspective > minPerspective &&
                  details.delta.dy > 0) {
                if (perspective - perspectiveStep <= minPerspective) {
                  perspective = minPerspective;
                } else {
                  perspective -= perspectiveStep;
                }
              }
              //

              if (x < centre && !_onTop && details.delta.dy < 0) {
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
                active = true;
              } else {
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
              //
            });
          },
          child: SizedBox(
            height: 200.0,
            width: 300.0,
            child: Card(
                color: widget.color,
                elevation: active ? 40 : 20,
                shadowColor: active ? Colors.black : Colors.black26,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: active ? 2 : 1,
                    color: active ? HexColor('#bbb5c3') : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    '${widget.index}',
                  ),
                  // child: _card(),
                )),
          ),
        ),
      ),
    );
  }
}

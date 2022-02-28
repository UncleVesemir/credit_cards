import 'package:flutter/material.dart';

class BookWidget extends StatefulWidget {
  const BookWidget({Key? key}) : super(key: key);

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  Widget _bottomElement() {
    return Container(
      width: 250,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBookWidgetController(
          children: [
            for (var i = 0; i < 3; i++)
              TopItemController(
                key: UniqueKey(),
                distanceBetween: i * 10,
              ),
          ],
          width: 250,
          heigth: 200,
        ),
      ],
    );
  }
}

enum Position {
  top,
  bottom,
}

class TopBookWidgetController extends StatefulWidget {
  final List<Widget> children;
  final double width;
  final double heigth;
  const TopBookWidgetController({
    required this.width,
    required this.heigth,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  State<TopBookWidgetController> createState() =>
      _TopBookWidgetControllerState();
}

class _TopBookWidgetControllerState extends State<TopBookWidgetController> {
  double position = 0;

  Matrix4? startMatrix;

  @override
  void initState() {
    super.initState();
  }

  void _setPosition() {
    startMatrix = Matrix4(
      //
      1, 0, 0, 0,
      0, 1, 0, 0.0007,
      0, 0, 1, 0,
      0, 0, 0, 1,
    );

    setState(() {
      position = MediaQuery.of(context).size.height / 2 - 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    _setPosition();
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - widget.width / 2,
      bottom: position,
      child: Stack(
        children: widget.children,
      ),
    );
  }
}

class TopItemController extends StatefulWidget {
  final double distanceBetween;
  const TopItemController({Key? key, required this.distanceBetween})
      : super(key: key);

  @override
  State<TopItemController> createState() => _TopItemControllerState();
}

class _TopItemControllerState extends State<TopItemController> {
  double position = 0;

  Matrix4? startMatrix;

  void _setPosition() {
    startMatrix = Matrix4(
      //
      1, 0, 0, 0,
      0, 1, 0, 0.0007,
      0, 0, 1, 0,
      0, 0, 0, 1,
    );

    setState(() {
      position = MediaQuery.of(context).size.height / 2 - 7;
    });
  }

  Widget _topElement() {
    return Container(
      width: 250,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position,
      child: Transform(
          transform: startMatrix!,
          alignment: FractionalOffset.center,
          child: _topElement()),
    );
  }
}

import 'package:flutter/material.dart';

class FabScreen extends StatefulWidget {
  const FabScreen({Key? key}) : super(key: key);

  @override
  State<FabScreen> createState() => _FabScreenState();
}

class _FabScreenState extends State<FabScreen> {
  Widget _increaseButton() {
    return ClipPath(
      clipper: GetClipper(),
      child: Container(
        height: 130,
        width: 80,
        color: Colors.grey.withOpacity(0.6),
      ),
    );
  }

  Widget _decreaseButton() {
    return Transform(
      transform: Matrix4(
        //
        1, 0, 0, 0.001,
        0, 0.9, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Colors.grey.withOpacity(0.3),
          ),
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        height: 130,
        width: 80,
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(400, 50),
                    topRight: Radius.elliptical(400, 50),
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // _decreaseButton(),
                          // const Text('20'),
                          // _increaseButton(),
                          const Spacer(),
                        ],
                      ),
                      AnimatedButton(
                        onTap: () {
                          print('tapped');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 50;
    double pi = 3.14;

    double extra = 20;

    Path path = Path()
      ..lineTo(size.width - radius, extra)
      ..arcTo(
          Rect.fromPoints(Offset(size.width - radius, extra),
              Offset(size.width, radius)), // Rect
          1.5 * pi, // Start engle
          0.5 * pi, // Sweep engle
          true) // direction clockwise
      ..lineTo(size.width, size.height - radius)
      ..arcTo(
          Rect.fromCircle(
              center: Offset(size.width - radius, size.height - radius),
              radius: radius),
          0,
          0.5 * pi,
          false)
      ..lineTo(radius, size.height)
      ..arcTo(Rect.fromLTRB(0, size.height - radius, radius, size.height),
          0.5 * pi, 0.5 * pi, false)
      ..lineTo(0, radius)
      ..arcTo(Rect.fromLTWH(0, 0, 70, 100), 1 * pi, 0.5 * pi, false)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnimatedButton extends StatefulWidget {
  final Function() onTap;
  const AnimatedButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  double startWidth = 100.0;
  double startHeight = 100.0;

  @override
  void initState() {
    super.initState();
    animationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1,
      lowerBound: 0.7,
      upperBound: 1,
    );
    animation = Tween(begin: 1, end: 2).animate(animationController!);

    animationController?.addListener(() {
      setState(() {});
    });
  }

  void onTapCancel() {
    animationController?.forward();
  }

  void onTapUp(TapUpDetails details) {
    animationController?.forward();
    widget.onTap();
  }

  void onTapDown(TapDownDetails details) {
    animationController?.animateBack(0.4);
  }

  @override
  Widget build(BuildContext context) {
    var animationValue = animationController?.value ?? 1;
    return Container(
      width: startWidth * animationValue,
      height: startHeight * animationValue,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            spreadRadius: 11,
            color: Colors.deepOrange.withOpacity(0.65),
            offset: const Offset(15, 15),
            blurRadius: 35,
          )
        ],
      ),
      child: GestureDetector(
        onTapCancel: onTapCancel,
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 0.85,
              colors: [
                Colors.yellowAccent.withOpacity(0.6),
                Colors.deepOrange.withOpacity(animationValue),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
            size: 35 * animationValue,
          ),
        ),
      ),
    );
  }
}

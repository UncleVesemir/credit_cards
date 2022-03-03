import 'package:flutter/material.dart';

class FabScreen extends StatefulWidget {
  const FabScreen({Key? key}) : super(key: key);

  @override
  State<FabScreen> createState() => _FabScreenState();
}

class _FabScreenState extends State<FabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Container(
          child: AnimatedButton(
            onTap: () {
              print('tapped');
            },
          ),
        ),
      ),
      // floatingActionButton: _buildFAB(),
    );
  }
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
        // borderRadius: BorderRadius.circular(100),
        shape: BoxShape.circle,
        // color: Colors.red,
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

// class OpenPainter extends CustomPainter {
//   final double x;
//   final double y;
//   final double radius;

//   OpenPainter(this.x, this.y, this.radius);

//   @override
//   void paint(Canvas canvas, Size size) {
//     var drawCircle = Paint()
//       // ..shader = const RadialGradient(
//       //   colors: [
//       //     Colors.yellowAccent,
//       //     Colors.deepOrange,
//       //   ],
//       // ).createShader(Rect.fromCircle(
//       //   center: Offset(150, 20),
//       //   radius: 10,
//       // ));
//       ..shader = ui.Gradient.linear(
//         Offset(0, 0),
//         Offset(80, 90),
//         [
//           Colors.yellowAccent,
//           Colors.deepOrange,
//         ],
//       );
//     canvas.drawCircle(Offset(x, -y), radius, drawCircle);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

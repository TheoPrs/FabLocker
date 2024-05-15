import 'package:flutter/material.dart';
import 'dart:math';

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  BubblePainter({required this.bubbles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (final bubble in bubbles) {
       paint.color = bubble.color;
      canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  double x;
  double y;
  double size;
  Color color;
  double speedX;
  double speedY;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
     required this.color,
    required this.speedX,
    required this.speedY,
  });
}

class BubbleBackground extends StatefulWidget {
  const BubbleBackground({Key? key}) : super(key: key);

  @override
  _BubbleBackgroundState createState() => _BubbleBackgroundState();
}

class _BubbleBackgroundState extends State<BubbleBackground> with TickerProviderStateMixin {
  late AnimationController _moveController;
  List<Bubble> bubbles = [];  // Initialisation à une liste vide
  final random = Random();



  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_updateBubblePositions)
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          bubbles = List.generate(50, (index) {
            return Bubble(
              x: random.nextDouble() * MediaQuery.of(context).size.width,
              y: random.nextDouble() * MediaQuery.of(context).size.height,
              size: random.nextDouble() * 30 + 12,
              color: const Color.fromARGB(255, 201, 191, 191).withOpacity(0.2 + random.nextDouble() * 0.1),
              speedX: random.nextDouble() * 4 - 2,
              speedY: random.nextDouble() * 4 - 2,
            );
          });
        });
      }
    });
  }

  void _updateBubblePositions() {
    if (bubbles.isNotEmpty) {  // Assure que bubbles contient des éléments avant de les mettre à jour
      setState(() {
        for (final bubble in bubbles) {
          bubble.x += bubble.speedX;
          bubble.y += bubble.speedY;
          if (bubble.x < 0 || bubble.x > MediaQuery.of(context).size.width) bubble.speedX *= -1;
          if (bubble.y < 0 || bubble.y > MediaQuery.of(context).size.height) bubble.speedY *= -1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bubbles.isNotEmpty ? CustomPaint(
      painter: BubblePainter(bubbles: bubbles),
      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
    ) : SizedBox.shrink();  // Retourne un widget vide si bubbles est vide
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }
}

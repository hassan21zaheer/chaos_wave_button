import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';

class WaveButton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<Color> lineColors;
  final Duration animationDuration;
  final VoidCallback? onTap;
  final String text;
  final TextStyle? textStyle;
  final Border? border;

  const WaveButton({
    super.key,
    this.width = 200.0,
    this.height = 60.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.backgroundColor = Colors.black,
    this.lineColors = const [
      Colors.purpleAccent, Colors.blue, Colors.orange, Colors.green
    ],
    this.animationDuration = const Duration(milliseconds: 500),
    this.onTap,
    this.text = '',
    this.textStyle,
    this.border
  });

  @override
  WaveButtonState createState() => WaveButtonState();
}

class WaveButtonState extends State<WaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _tapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (await Vibration.hasVibrator() ) {
      Vibration.vibrate(duration: 200); // Vibrate for 200ms
    } else {
    }
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: widget.border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _tapAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    tapValue: _tapAnimation.value,
                    resolution: Size(widget.width, widget.height),
                    time: _controller.value *
                        widget.animationDuration.inMilliseconds /
                        1000.0,
                    lineColors: widget.lineColors,
                    borderRadius: widget.borderRadius,
                  ),
                  child: Container(),
                );
              },
            ),
            if (widget.text.isNotEmpty) // Only show text if provided
              Text(
                widget.text,
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double tapValue;
  final Size resolution;
  final double time;
  final List<Color> lineColors;
  final BorderRadius borderRadius;

  WavePainter({
    required this.tapValue,
    required this.resolution,
    required this.time,
    required this.lineColors,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Consistent seed for reproducible chaos
    final lineCount = 6; // Fixed number of lines

// Clip to button's rounded rectangle boundaries
    canvas.clipRRect(borderRadius.toRRect(Offset.zero & size));

// Draw lines with neon metallic effect
    for (int i = 0; i < lineCount; i++) {
      final colorIndex = i % lineColors.length;
      final baseColor = lineColors[colorIndex];

// Create vibrant gradient for neon metallic look
      final gradient = LinearGradient(
        colors: [
          baseColor.withOpacity(0.4), // Brighter start
          baseColor, // Full vibrancy
          baseColor.withOpacity(0.4), // Brighter end
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth =
            2.5 + random.nextDouble() * 1.5 // Thicker lines: 2.5–4.0
        ..shader = gradient
        ..maskFilter =
        const MaskFilter.blur(BlurStyle.normal, 3.0); // Stronger glow

// Randomize start and end y-positions
      final startY =
          random.nextDouble() * size.height; // Random y within button
      final endY = random.nextDouble() * size.height; // Different random y
      final wavelength =
          0.05 + random.nextDouble() * 0.1; // Random wavelength: 0.05–0.15
      final amplitude =
          5.0 + random.nextDouble() * 5.0; // Random amplitude: 5–10

// Draw wave-like line with segments
      final points = <Offset>[];
      for (double x = 0; x <= size.width; x += 2.0) {
// Calculate y with wave effect
        final t = x / size.width;
        final y = startY +
            (endY - startY) * t + // Linear interpolation
            math.sin(x * wavelength + time * 2.0 + i) * amplitude * tapValue;
        points.add(Offset(x, y));
      }

// Draw line segments
      for (int j = 0; j < points.length - 1; j++) {
        canvas.drawLine(
          points[j],
          points[j + 1],
          paint..color = baseColor.withOpacity(tapValue * 0.9), // Vibrant fade
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.tapValue != tapValue ||
        oldDelegate.time != time ||
        oldDelegate.resolution != resolution ||
        oldDelegate.lineColors != lineColors ||
        oldDelegate.borderRadius != borderRadius;
  }
}






class ChaosButton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<Color> lineColors;
  final Duration animationDuration;
  final VoidCallback? onTap;
  final String text;
  final TextStyle? textStyle;
  final Border? border;
  final double intensity;

  const ChaosButton({
    super.key,
    this.width = 200.0,
    this.height = 60.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.backgroundColor = Colors.black,
    this.lineColors = const [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.cyanAccent,
      Colors.lightGreenAccent
    ],
    this.animationDuration = const Duration(milliseconds: 800),
    this.onTap,
    this.text = '',
    this.textStyle,
    this.border,
    this.intensity = 1.0,
  });

  @override
  ChaosButtonState createState() => ChaosButtonState();
}

class ChaosButtonState extends State<ChaosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapAnimation;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _tapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 200); // Vibrate for 200ms
    } else {
    }
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: widget.border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _tapAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ChaosPainter(
                      tapValue: _tapAnimation.value,
                      resolution: Size(widget.width, widget.height),
                      time: DateTime.now().millisecondsSinceEpoch / 1000,
                      lineColors: widget.lineColors,
                      borderRadius: widget.borderRadius,
                      intensity: widget.intensity,
                      random: _random,
                      backgroundColor: widget.backgroundColor
                  ),
                  child: Container(),
                );
              },
            ),
            if (widget.text.isNotEmpty)
              Text(
                widget.text,
                style: widget.textStyle ??
                    TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class ChaosPainter extends CustomPainter {
  final double tapValue;
  final Size resolution;
  final double time;
  final List<Color> lineColors;
  final BorderRadius borderRadius;
  final double intensity;
  final math.Random random;
  final Color backgroundColor;

  ChaosPainter({
    required this.tapValue,
    required this.resolution,
    required this.time,
    required this.lineColors,
    required this.borderRadius,
    required this.intensity,
    required this.random,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Clip to button's rounded rectangle boundaries
    final clipRRect = borderRadius.toRRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.clipRRect(clipRRect);

    // Draw a subtle metallic background gradient
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Number of lines based on intensity
    final lineCount = (6 * intensity).round();
    final maxLines = 12;
    final activeLineCount = (lineCount * tapValue).round().clamp(1, maxLines);

    // Draw electric current-like lines
    for (int i = 0; i < activeLineCount; i++) {
      final colorIndex = i % lineColors.length;
      final baseColor = lineColors[colorIndex];

      // Random properties for each line
      final lineSpeed = 5.0 + random.nextDouble() * 10.0 * intensity;
      final lineThickness = 1.0 + random.nextDouble() * 2.0 * intensity;
      final isJagged = random.nextDouble() > 0.3;
      final isFast = random.nextDouble() > 0.7;
      final segmentLength = isFast ? 4.0 : 8.0;

      // Create electric current effect
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = lineThickness
        ..color = baseColor.withOpacity((0.7 + random.nextDouble() * 0.3) * tapValue)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          lineThickness * 1.5 * tapValue,
        );

      // Random start and end positions
      final startY = random.nextDouble() * size.height;
      final endY = startY + (random.nextDouble() * 40 - 20) * intensity;
      final clampedEndY = endY.clamp(0.0, size.height);

      // Create jagged or smooth path
      final path = Path();
      final points = <Offset>[];

      for (double x = 0; x <= size.width; x += segmentLength) {
        // Time-based movement for electric effect
        final timeFactor = time * lineSpeed;

        // Add randomness to create chaotic movement
        final randomFactor = random.nextDouble() * 2.0;
        final noise = math.sin(x * 0.1 + timeFactor + i * 10) *
            math.cos(timeFactor * 0.5 + i) *
            15.0 * intensity;

        // Calculate y position with different patterns
        double y;
        if (isJagged) {
          // Create sharp jagged lightning effect
          y = startY +
              (clampedEndY - startY) * (x / size.width) +
              noise * randomFactor;
        } else {
          // Create smoother but still chaotic wave
          y = startY +
              (clampedEndY - startY) * (x / size.width) +
              math.sin(x * 0.2 + timeFactor) * 10.0 * intensity;
        }

        y = y.clamp(0.0, size.height);
        points.add(Offset(x, y));
      }

      // Draw the line segments with occasional breaks to simulate electricity
      for (int j = 0; j < points.length - 1; j++) {
        // Randomly skip segments to create broken electric effect
        if (random.nextDouble() > 0.1) {
          path.moveTo(points[j].dx, points[j].dy);
          path.lineTo(points[j + 1].dx, points[j + 1].dy);
        }
      }

      canvas.drawPath(path, paint);

      // Add occasional bright spots for electric feel
      if (random.nextDouble() > 0.7) {
        final brightSpotPaint = Paint()
          ..color = baseColor.withOpacity(0.8 * tapValue)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0);

        final spotX = random.nextDouble() * size.width;
        final spotY = startY + (clampedEndY - startY) * (spotX / size.width);
        canvas.drawCircle(
          Offset(spotX, spotY),
          random.nextDouble() * 3.0 * intensity,
          brightSpotPaint,
        );
      }
    }

    // Add subtle border glow
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.1 * tapValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawRRect(clipRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ChaosPainter oldDelegate) {
    return oldDelegate.tapValue != tapValue ||
        oldDelegate.time != time ||
        oldDelegate.resolution != resolution ||
        oldDelegate.lineColors != lineColors ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.intensity != intensity;
  }
}

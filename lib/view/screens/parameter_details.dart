import 'package:flutter/material.dart';

class ParameterDetailScreen extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String unit;
  final IconData icon;
  final Color statusColor;

  const ParameterDetailScreen({
    Key? key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.icon,
    required this.statusColor,
  }) : super(key: key);

  String _getInsightMessage() {
    double normalized = ((value - min) / (max - min)).clamp(0.0, 1.0);
    if (normalized > 0.66)
      return 'The ${title.toLowerCase()} is currently elevated. Monitoring closely. System adjustments may be required if this trend continues over the next hour.';
    if (normalized > 0.33)
      return 'The ${title.toLowerCase()} is within acceptable limits but slightly above optimal targets. No manual intervention needed at this moment.';
    return 'The ${title.toLowerCase()} level is optimal and stable. System running at maximum efficiency. Good growing conditions maintained.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: ClayContainer(
              borderRadius: 20,
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF1E293B),
                size: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.network(
                'https://images.unsplash.com/photo-1497250681554-fc1da9e34829?q=80&w=800&auto=format&fit=crop',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: const Color(0xFF1B5E20),
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: const Color(0xFFE8F5E9)),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Hero Card
                  Hero(
                    tag: 'card_$title',
                    flightShuttleBuilder:
                        (
                          flightContext,
                          animation,
                          flightDirection,
                          fromHeroContext,
                          toHeroContext,
                        ) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: DefaultTextStyle(
                              style: DefaultTextStyle.of(toHeroContext).style,
                              child: toHeroContext.widget,
                            ),
                          );
                        },
                    child: Material(
                      type: MaterialType.transparency,
                      child: ClayContainer(
                        padding: const EdgeInsets.all(32),
                        borderRadius: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      ClayContainer(
                                        concave: true,
                                        padding: const EdgeInsets.all(12),
                                        borderRadius: 20,
                                        child: Icon(
                                          icon,
                                          color: statusColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1E293B),
                                            letterSpacing: -0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${value.toStringAsFixed(1)}$unit',
                                      style: const TextStyle(
                                        fontSize: 64,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1E293B),
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Implicitly Animated Details Content
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, animValue, child) {
                      return Opacity(
                        opacity: animValue,
                        child: Transform.translate(
                          offset: Offset(0, 40 * (1 - animValue)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Historical Data',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClayContainer(
                          padding: const EdgeInsets.all(0),
                          concave: true, // Inset look for graph area
                          child: SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  top: 40,
                                  bottom: 20,
                                  child: CustomPaint(
                                    painter: _ClayMockGraphPainter(
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.auto_graph_rounded,
                                        size: 48,
                                        color: statusColor.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Live Data Processing...',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'System Insights',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClayContainer(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              ClayContainer(
                                concave: true,
                                padding: const EdgeInsets.all(14),
                                borderRadius: 20,
                                child: Icon(
                                  Icons.tips_and_updates_rounded,
                                  color: statusColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  _getInsightMessage(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Foreground Plant Decoration at base
          Positioned(
            bottom: -40,
            left: -30,
            right: -30,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.15,
                child: Image.network(
                  'https://images.unsplash.com/photo-1599598425947-3300262108bf?q=80&w=800&auto=format&fit=crop', // Isolated Monstera leaf style
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SHARED CLAYMORPHISM EFFECTS
// ==========================================

class ClayContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool concave;
  final Color baseColor;

  const ClayContainer({
    Key? key,
    required this.child,
    this.borderRadius = 32,
    this.padding,
    this.concave = false,
    this.baseColor = const Color(0xFFE8F5E9),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: concave
            ? [
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: const Color(0xFFC8E6C9).withOpacity(0.8),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(-10, -10),
                ),
                BoxShadow(
                  color: const Color(0xFFA5D6A7).withOpacity(0.6),
                  blurRadius: 20,
                  offset: const Offset(10, 10),
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: concave
              ? [
                  const Color(0xFFE0E0E0).withOpacity(0.1),
                  Colors.white.withOpacity(0.5),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  const Color(0xFFE8F5E9).withOpacity(0.5),
                ],
        ),
      ),
      child: child,
    );
  }
}

class _ClayMockGraphPainter extends CustomPainter {
  final Color color;
  _ClayMockGraphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Soft shadow under the line
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.9,
      size.width * 0.4,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width * 0.8,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.5,
      size.width,
      size.height * 0.2,
    );

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ClayMockGraphPainter oldDelegate) => false;
}

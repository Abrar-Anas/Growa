import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/glassbottomnav.dart';
import 'package:growa/view/screens/home_screen/home_screen.dart';
import 'package:growa/view/screens/stats/stats_screen_two.dart';
import 'package:growa/view/screens/user_screen/user_screen.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final PageController pageController = PageController(initialPage: 1);

  final ValueNotifier<double> leftPosition = ValueNotifier<double>(0.0);

  final ValueNotifier<int> activeIndex = ValueNotifier<int>(1);

  final List<IconData> icons = [Icons.auto_graph, Icons.home, Icons.person];

  final List<String> labelData = ["STATS", "HOME", "USER"];

  final List<Widget> screens = [
    StatsScreenTwo(),
    HomeScreen(),
    UserScreen(), // Replace with UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      drawer: Drawer(),
      appBar: _appBar(),
      backgroundColor: tint,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          activeIndex.value = index;
          // Note: The bar position logic is handled in the LayoutBuilder below
        },
        children: screens,
      ),
    );
  }

  Padding _bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double barWidth = constraints.maxWidth;
          double itemWidth = barWidth / icons.length;

          // Set initial position
          WidgetsBinding.instance.addPostFrameCallback((_) {
            leftPosition.value = activeIndex.value * itemWidth;
          });

          return GestureDetector(
            // --- LIQUID SWIPE ---
            onHorizontalDragUpdate: (details) {
              // The glass moves freely with the finger
              double newPos = (leftPosition.value + details.delta.dx).clamp(
                0.0,
                barWidth - itemWidth,
              );
              leftPosition.value = newPos;

              // Update active index (for icon color/zoom) based on current position
              activeIndex.value = (newPos / itemWidth).round();
            },
            onHorizontalDragEnd: (details) {
              // --- SNAP & SWITCH LOGIC ---
              // 1. Determine final resting index
              int targetIndex = (leftPosition.value / itemWidth).round();

              // 2. Animate the glass oval to the exact icon center
              leftPosition.value = targetIndex * itemWidth;
              activeIndex.value = targetIndex;

              // 3. ONLY NOW change the page
              pageController.animateToPage(
                targetIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // --- ZOOMING GLASS OVAL ---
                  ValueListenableBuilder<double>(
                    valueListenable: leftPosition,
                    builder: (context, pos, _) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves
                            .easeOutBack, // Back curve adds a slight "overshoot" zoom
                        left: pos + (itemWidth * 0.1),
                        top: 12,
                        child: ValueListenableBuilder<int>(
                          valueListenable: activeIndex,
                          builder: (context, idx, _) {
                            // TweenAnimationBuilder handles the scale "zoom"
                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              key: ValueKey(
                                idx,
                              ), // Re-triggers zoom on index change
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: GlassOval(width: itemWidth * 0.8),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // --- ICONS ---
                  Row(
                    children: List.generate(icons.length, (i) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            activeIndex.value = i;
                            leftPosition.value = i * itemWidth;
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutBack,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: ValueListenableBuilder<int>(
                            valueListenable: activeIndex,
                            builder: (context, idx, _) {
                              return AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: idx == i
                                    ? 1.2
                                    : 1.0, // Subtle icon zoom too
                                child: Column(
                                  children: [
                                    Spacer(),

                                    Icon(
                                      icons[i],
                                      color: idx == i ? green : Colors.white,
                                    ),
                                    Text(
                                      labelData[i],
                                      style: TextStyle(
                                        color: idx == i ? green : Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: tint,
    centerTitle: true,
    title: Text(
      "Growa",
      style: TextStyle(
        color: green,
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/model/glassbottomnav.dart';
import 'package:growa/view/screens/disease/disease_listing_page.dart';
import 'package:growa/view/screens/home_screen/home_screen.dart';
import 'package:growa/view/screens/user_screen/user_screen.dart';

class DashBoard extends StatelessWidget {
  DashBoard({
    this.isAutomated = false,
    this.onToggleMode,
    this.wsStatus = 0,
    super.key,
  });

  final PageController pageController = PageController(initialPage: 1);

  final ValueNotifier<double> leftPosition = ValueNotifier<double>(0.0);

  final ValueNotifier<int> activeIndex = ValueNotifier<int>(1);

  final double fixedGlassWidth = 90;

  final List<IconData> icons = [Icons.dangerous, Icons.home, Icons.person];

  final List<String> labelData = ["DISEASE", "HOME", "USER"];

  final List<Widget> screens = [DiseaseListPage(), HomeScreen(), UserScreen()];
  final bool isAutomated;
  final int wsStatus;
  final VoidCallback? onToggleMode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      drawer: Drawer(),
      appBar: ClayAppBar(
        isAutomated: isAutomated,
        wsStatus: wsStatus,
        onToggleMode: () => onToggleMode?.call(),
      ),
      backgroundColor: tint,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            // This is the magic part: it calculates exactly where the glass should be
            // based on the PageView's current scroll position.
            double barWidth =
                MediaQuery.of(context).size.width -
                48; // 48 is the horizontal padding (24*2)
            double itemWidth = barWidth / icons.length;

            if (pageController.hasClients) {
              leftPosition.value = pageController.page! * itemWidth;
              activeIndex.value = pageController.page!.round();
            }
          }
          return false;
        },
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            activeIndex.value = index;
          },
          children: screens,
        ),
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

          WidgetsBinding.instance.addPostFrameCallback((_) {
            leftPosition.value = activeIndex.value * itemWidth;
          });

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              double newPos = (leftPosition.value + details.delta.dx).clamp(
                0.0,
                barWidth - itemWidth,
              );
              leftPosition.value = newPos;
              activeIndex.value = (newPos / itemWidth).round();
            },
            onHorizontalDragEnd: (details) {
              int targetIndex = (leftPosition.value / itemWidth).round();

              leftPosition.value = targetIndex * itemWidth;
              activeIndex.value = targetIndex;

              pageController.animateToPage(
                targetIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              height: 75.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(40).r,
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
                  ValueListenableBuilder<double>(
                    valueListenable: leftPosition,
                    builder: (context, pos, _) {
                      double centerposition =
                          pos + (itemWidth / 2) - (fixedGlassWidth / 2);
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        left: centerposition,
                        top: 12.h,
                        child: ValueListenableBuilder<int>(
                          valueListenable: activeIndex,
                          builder: (context, idx, _) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              key: ValueKey(idx),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: GlassOval(width: fixedGlassWidth),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

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
                                scale: idx == i ? 1.2 : 1.0,
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

// AppBar _appBar() {
//   return AppBar(
//     backgroundColor: tint,
//     actions: [
//       CircleAvatar(
//         backgroundColor: Colors.green.shade500,
//         child: Text(
//           "A",
//           style: TextStyle(color: white, fontWeight: FontWeight.w400),
//         ),
//       ),
//     ],
//     actionsPadding: EdgeInsets.all(12),
//     centerTitle: true,
//     title: Text(
//       "Growa",
//       style: TextStyle(
//         color: green,
//         fontWeight: FontWeight.bold,
//         fontSize: 30.sp,
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:growa/model/colors/colors.dart';
import 'package:growa/view/screens/sign_in_screen/sign_in_screen.dart';

class IntroScreenOne extends StatelessWidget {
  IntroScreenOne({super.key});
  final PageController _controller = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "grow logo",
                child: Text(
                  "WELCOME",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.r,
                  ),
                ),
              ),
              10.verticalSpace,
              _introBox(),
            ],
          ),
        ),
      ),
      floatingActionButton: _skipButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  ValueListenableBuilder<int> _skipButton() {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (context, pageIndex, child) {
        return SizedBox(
          width: 68,
          height: 31,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return SignInScreen();
                  },
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(6),
            ),
            child: Text(
              pageIndex < 2 ? "Skip" : "Done",
              style: TextStyle(
                color: tfcolor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Stack _introBox() {
    return Stack(
      alignment: AlignmentGeometry.xy(0, 0.9),
      children: [
        Container(
          width: 332.r,
          height: 512.r,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        SizedBox(
          width: 332.r,
          height: 512.r,
          child: PageView(
            controller: _controller,
            onPageChanged: (value) => _currentPage.value = value,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  10.verticalSpace,
                  Image.asset(
                    "assets/image/intro-image-one.png",
                    width: 291.r,
                    height: 291.r,
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 35).r,
                    child: Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "TO \nGROWA",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.r,
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,

                  10.verticalSpace,
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/image/intro-image-two.png",
                    width: 291.r,
                    height: 291.r,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35).r,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Were We",
                            style: TextStyle(
                              color: yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.r,
                            ),
                          ),
                          Text(
                            "Monitor \nAutomate \nGrow",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/image/intro-image-three.png",
                    width: 291.r,
                    height: 291.r,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35).r,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Join Us",
                            style: TextStyle(
                              color: yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.r,
                            ),
                          ),
                          Text(
                            "And Grow \nWith Growa",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ],
          ),
        ),

        ValueListenableBuilder(
          valueListenable: _currentPage,

          builder: (contex, activePage, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(microseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 10).r,
                  width: 19.r,
                  height: 19.r,
                  decoration: BoxDecoration(
                    color: activePage == index ? tfcolor : white,
                    shape: BoxShape.circle,
                    border: Border.all(color: black, width: 0),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

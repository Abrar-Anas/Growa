import 'package:flutter/material.dart';
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
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(height: 10),
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
          width: 332,
          height: 512,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(
          width: 332,
          height: 512,
          child: PageView(
            controller: _controller,
            onPageChanged: (value) => _currentPage.value = value,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    "assets/image/intro-image-one.png",
                    width: 291,
                    height: 291,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 35),
                    child: Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "TO \nGROWA",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 10),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/image/intro-image-two.png",
                    width: 291,
                    height: 291,
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Were We",
                            style: TextStyle(
                              color: yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "Monitor \nAutomate \nGrow",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/image/intro-image-three.png",
                    width: 291,
                    height: 291,
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 35),
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
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "And Grow \nWith Growa",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 19,
                  height: 19,
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

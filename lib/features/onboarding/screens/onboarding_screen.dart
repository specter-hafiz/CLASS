import 'package:auto_size_text/auto_size_text.dart';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/data/onboarding_data.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: PageView.builder(
          dragStartBehavior: DragStartBehavior.down,
          controller: _controller,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: onboardingData.length,
          itemBuilder: (context, index) {
            final item = onboardingData[index];
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizedBox(height: SizeConfig.blockSizeVertical! * 10)
                      : SizedBox(height: SizeConfig.blockSizeVertical! * 10),
                  // Display the SVG image
                  SvgPicture.asset(
                    item["image"]!,
                    width: SizeConfig.screenWidth!,
                    height: SizeConfig.screenHeight! * 0.4,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                  AutoSizeText(
                    item["title"]!,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 5.5
                              : SizeConfig.blockSizeHorizontal! * 3,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                  AutoSizeText(
                    item["subtitle"]!,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 5
                              : SizeConfig.blockSizeHorizontal! * 2.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 5
                            : SizeConfig.blockSizeVertical! * 3,
                  ),

                  SmoothPageIndicator(
                    controller: _controller,
                    count: onboardingData.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 1.1,
                      dotColor: Color(greyColor),
                      dotHeight: 10,
                      dotWidth: 30,
                      activeDotColor: Color(blueColor),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 8),

                  CustomElevatedButton(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 6
                            : SizeConfig.blockSizeHorizontal! * 5,
                    borderRadius:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal! * 3
                            : SizeConfig.blockSizeHorizontal! * 1,
                    onPressed: nextPage,
                    buttonText:
                        _currentPage < onboardingData.length - 1
                            ? nextButtonText
                            : getStartedButtonText,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

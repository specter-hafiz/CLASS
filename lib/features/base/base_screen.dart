import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/analytics/presentation/screens/analytics_screen.dart';
import 'package:class_app/features/tutor/home/presentation/screens/home_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/profile_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomeScreen(), QuizScreen(), AnalyticsScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical! * 3),
        decoration: BoxDecoration(
          color: Color(greyColor).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeHorizontal! * 10,
          ),
        ),
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal! * 1),
        child: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              SizeConfig.blockSizeHorizontal! * 10,
            ),
          ),
          onPressed: () {
            // Add your floating action button action here
          },
          backgroundColor: Color(blueColor),
          child: SvgPicture.asset(
            "assets/svgs/mic.svg",
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.height * 0.045,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Color(greyColor),
        selectedItemColor: Color(blueColor),
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svgs/home.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Color(blueColor) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svgs/quiz.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Color(blueColor) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svgs/analytics.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Color(blueColor) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/svgs/profile.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Color(blueColor) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/analytics/presentation/widgets/score_frequency_chart.dart';
import 'package:flutter/material.dart';

class DetailAnalyticsScreen extends StatelessWidget {
  const DetailAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, int> data = {
      12: 2,
      18: 3,
      22: 5,
      25: 4,
      31: 6,
      35: 7,
      39: 6,
      42: 10,
      45: 11,
      48: 9,
      51: 12,
      53: 15,
      56: 18,
      58: 16,
      60: 20,
      63: 22,
      65: 26,
      67: 24,
      69: 22,
      72: 30,
      74: 28,
      76: 34,
      78: 32,
      81: 36,
      83: 35,
      85: 30,
      87: 28,
      90: 24,
      92: 20,
      95: 18,
      97: 14,
      99: 10,
    };

    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: Text(
          lectureWeekText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 6
                    : SizeConfig.blockSizeVertical! * 7,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizedBox.shrink()
                  : SizedBox(height: SizeConfig.blockSizeVertical! * 5),

              ScoreFrequencyChart(scoreFrequency: data),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              CustomElevatedButton(
                buttonText: exportResultsText,
                onPressed: () {},
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 200, // or dynamic count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? 1.2
                          : 2.2,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(greyColor)),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeVertical! * 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Q${index + 1}"), // Make dynamic if needed
                        Text(
                          "299/500",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
            ],
          ),
        ),
      ),
    );
  }
}

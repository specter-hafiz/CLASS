import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TranscriptionScreen extends StatelessWidget {
  const TranscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 10
                        : SizeConfig.blockSizeVertical! * 7,
              ),
              Text(
                transcribingText,
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2.5
                          : SizeConfig.blockSizeVertical! * 5,
                  fontWeight: FontWeight.w500,
                  color: Color(blackColor),
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 10
                        : SizeConfig.blockSizeVertical! * 2,
              ),
              Center(
                child: CircularPercentIndicator(
                  radius:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 15
                          : SizeConfig.blockSizeVertical! * 20,
                  lineWidth:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 3.5
                          : SizeConfig.blockSizeVertical! * 5,
                  backgroundColor: Color(lightBlue),
                  percent: 0.7,
                  center: Text(
                    "70%",
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 4
                              : SizeConfig.blockSizeVertical! * 7,
                      fontWeight: FontWeight.bold,
                      color: Color(blackColor),
                    ),
                  ),
                  progressColor: Color(blueColor),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 10
                        : SizeConfig.blockSizeVertical! * 2,
              ),
              Text(
                transcribingOverText,
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2
                          : SizeConfig.blockSizeVertical! * 4,
                  fontWeight: FontWeight.w400,

                  color: Color(blackColor),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 10
                        : SizeConfig.blockSizeVertical! * 2,
              ),
              CustomElevatedButton(
                buttonText: cancelText,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

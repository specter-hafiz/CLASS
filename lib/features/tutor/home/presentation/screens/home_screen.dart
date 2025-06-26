import 'package:auto_size_text/auto_size_text.dart';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 2
                        : SizeConfig.blockSizeVertical! * 0.3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  AutoSizeText(
                    appNameText,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.screenWidth! * 0.09
                              : SizeConfig.screenWidth! * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 1
                            : SizeConfig.blockSizeHorizontal! * 0.5,
                  ),

                  AutoSizeText(
                    homeSubText,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.screenWidth! * 0.04
                              : SizeConfig.screenWidth! * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 3
                        : SizeConfig.blockSizeVertical! * 1,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: recordText,
                      showIcon: true,
                      iconPath: micOutlineImage,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      isOutlineButton: true,
                      buttonText: importText,
                      showIcon: true,
                      iconPath: importImage,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 3),
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      recentTranscriptionsText,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.06
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: AutoSizeText(
                      viewAllText,
                      style: TextStyle(
                        color: Color(blueColor),
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.04
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10, // Replace with your data length
                  itemBuilder: (context, index) {
                    return CustomContainer(
                      titleText: 'Transcription ${index + 1}',
                      subText: '00:30:00 | 407 words',
                      showTrailingIcon: true,
                      onTap: () {
                        // Handle tap action
                      },
                      onMoreTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

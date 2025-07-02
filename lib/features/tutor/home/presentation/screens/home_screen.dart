import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/recording_bottom_sheet.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isPortrait = SizeConfig.orientation(context) == Orientation.portrait;

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
                  Text(
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

                  Text(
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
                      onPressed: () async {
                        await showModalBottomSheet(
                          constraints: BoxConstraints(
                            maxHeight:
                                isPortrait
                                    ? SizeConfig.screenHeight! * 0.7
                                    : SizeConfig.screenHeight! * 0.95,
                          ),
                          showDragHandle: true,
                          isDismissible: false,
                          backgroundColor: Color(whiteColor),
                          context: context,
                          builder: (context) {
                            return RecordingBottomSheet(isPortrait: isPortrait);
                          },
                        );
                        // Navigator.pushNamed(context, '/audioRecorder');
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      isOutlineButton: true,
                      buttonText: importText,
                      showIcon: true,
                      iconColor: blueColor,
                      iconPath: importImage,
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              screenWidth: SizeConfig.screenWidth!,
                              screenHeight: SizeConfig.screenHeight!,
                              height:
                                  SizeConfig.orientation(context) ==
                                          Orientation.portrait
                                      ? SizeConfig.screenHeight! * 0.28
                                      : SizeConfig.screenHeight! * 0.6,
                              rightButtonText: transcribeText,
                              onRightButtonPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/transcribe');
                              },
                              body: Column(
                                children: [
                                  Text(
                                    importfileText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.orientation(context) ==
                                                  Orientation.portrait
                                              ? SizeConfig
                                                      .blockSizeHorizontal! *
                                                  6
                                              : SizeConfig.blockSizeVertical! *
                                                  6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical! * 2,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          importDocImage,
                                          height:
                                              SizeConfig.orientation(context) ==
                                                      Orientation.portrait
                                                  ? SizeConfig.screenHeight! *
                                                      0.09
                                                  : SizeConfig.screenHeight! *
                                                      0.2,
                                          width:
                                              SizeConfig.orientation(context) ==
                                                      Orientation.portrait
                                                  ? SizeConfig.screenHeight! *
                                                      0.09
                                                  : SizeConfig.screenHeight! *
                                                      0.2,
                                          colorFilter: ColorFilter.mode(
                                            Color(blueColor),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical! * 2,
                                        ),
                                        Text(
                                          tapUploadText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.orientation(
                                                          context,
                                                        ) ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeHorizontal! *
                                                        4
                                                    : SizeConfig
                                                            .blockSizeVertical! *
                                                        4,
                                            fontWeight: FontWeight.w500,
                                            color: Color(blueColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
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
                    child: Text(
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
                        Navigator.pushNamed(context, '/transcript_audio');
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

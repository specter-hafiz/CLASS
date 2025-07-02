import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/audio_player.dart';
import 'package:flutter/material.dart';

class TranscriptAudioScreen extends StatefulWidget {
  const TranscriptAudioScreen({super.key});

  @override
  State<TranscriptAudioScreen> createState() => _TranscriptAudioScreenState();
}

class _TranscriptAudioScreenState extends State<TranscriptAudioScreen> {
  int selectedIndex = 0;
  bool readOnly = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          meetingDiscussionText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 2.5
                    : SizeConfig.blockSizeVertical! * 6,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 0.5
                    : SizeConfig.blockSizeVertical! * 1,
              ),
              decoration: BoxDecoration(
                color: Color(lightBlue),
                borderRadius: BorderRadius.circular(
                  SizeConfig.blockSizeVertical! * 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      height:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 5
                              : SizeConfig.blockSizeVertical! * 10,
                      buttonText: transcriptText,
                      backgroundColor:
                          selectedIndex == 0 ? blueColor : transparentColor,
                      textColor: selectedIndex == 0 ? whiteColor : blueColor,
                      onPressed: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      height:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 5
                              : SizeConfig.blockSizeVertical! * 10,
                      buttonText: audioText,
                      textColor: selectedIndex == 1 ? whiteColor : blueColor,
                      backgroundColor:
                          selectedIndex == 1 ? blueColor : transparentColor,
                      onPressed: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  selectedIndex == 0
                      ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$durationText 45:12 min",
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.orientation(context) ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeVertical! * 2
                                          : SizeConfig.blockSizeVertical! * 5,
                                  color: Color(blackColor),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit_text');
                                },
                                child: Text(
                                  editText,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.orientation(context) ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeVertical! * 2
                                            : SizeConfig.blockSizeVertical! * 5,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    decorationColor: Color(blueColor),
                                    color: Color(blueColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text:
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),

                              maxLines: null,
                              readOnly: readOnly,
                            ),
                          ),
                          CustomElevatedButton(
                            buttonText: shareText,
                            onPressed: () {},
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                        ],
                      )
                      : AudioPlaybackScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

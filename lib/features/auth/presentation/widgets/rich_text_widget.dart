import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    super.key,
    required this.text,
    required this.actionText,
    this.onTap,
    this.fontSize,
  });
  final String text;
  final String actionText;
  final double? fontSize;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Color(blackColor),
            fontSize:
                fontSize ??
                (SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.screenWidth! * 0.04
                    : SizeConfig.screenWidth! * 0.025),
          ),
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(
                color: Color(blueColor),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}

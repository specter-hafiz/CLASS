import 'package:auto_size_text/auto_size_text.dart';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Color(greyColor), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal! * 2,
          ),
          child: Text(
            "or continue with ",
            style: TextStyle(
              color: Color(greyColor),
              fontSize:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.screenWidth! * 0.04
                      : SizeConfig.screenWidth! * 0.025,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
          ),
        ),
        Expanded(child: Divider(color: Color(greyColor), thickness: 1)),
      ],
    );
  }
}

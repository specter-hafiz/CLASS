import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onTap,
    this.isLast,
  });

  final String text;
  final String iconPath;
  final void Function()? onTap;
  final bool? isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Color(greyColor)),
        SizedBox(
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 0.2
                  : SizeConfig.blockSizeHorizontal! * 0.1,
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeVertical! * 1.2,
          ),
          splashColor: Color(lightBlue),
          child: Row(
            children: [
              Container(
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.13
                        : SizeConfig.screenWidth! * 0.065,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.13
                        : SizeConfig.screenWidth! * 0.065,
                decoration: BoxDecoration(
                  color: Color(blueColor),
                  borderRadius: BorderRadius.circular(
                    SizeConfig.blockSizeVertical! * 1.2,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.08
                            : SizeConfig.screenWidth! * 0.04,
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.08
                            : SizeConfig.screenWidth! * 0.04,
                  ),
                ),
              ),
              SizedBox(
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 3
                        : SizeConfig.blockSizeHorizontal! * 1,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.05
                            : SizeConfig.screenWidth! * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),

              SvgPicture.asset(
                forwardImage,
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.1
                        : SizeConfig.screenWidth! * 0.03,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.1
                        : SizeConfig.screenWidth! * 0.03,
              ),
            ],
          ),
        ),
        SizedBox(
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 0.2
                  : SizeConfig.blockSizeHorizontal! * 0.1,
        ),
        isLast != null
            ? Divider(color: Color(greyColor))
            : const SizedBox.shrink(),
      ],
    );
  }
}

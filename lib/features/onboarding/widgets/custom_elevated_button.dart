import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
    this.showIcon,
    this.iconPath,
    this.isOutlineButton,
    this.backgroundColor,
    this.textColor,
  });

  final void Function()? onPressed;
  final String buttonText;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool? showIcon;
  final String? iconPath;
  final bool? isOutlineButton;
  final int? backgroundColor;
  final int? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: Size(
          width ?? double.infinity,
          height ??
              (SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 6
                  : SizeConfig.blockSizeHorizontal! * 5),
        ),
        backgroundColor:
            isOutlineButton == true
                ? Color(whiteColor)
                : Color(backgroundColor ?? blueColor),
        elevation: 0,
        foregroundColor:
            isOutlineButton == true
                ? Color(blueColor)
                : Color(textColor ?? whiteColor),
        shape: RoundedRectangleBorder(
          side:
              isOutlineButton == true
                  ? BorderSide(color: Color(blueColor), width: 1.5)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(
            borderRadius ??
                (SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 3
                    : SizeConfig.blockSizeHorizontal! * 1),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon == true) ...[
            SvgPicture.asset(
              iconPath ?? googleImage,
              width:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 3
                      : SizeConfig.blockSizeHorizontal! * 5,
              height:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 3
                      : SizeConfig.blockSizeVertical! * 5,
            ),
            SizedBox(
              width:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 2
                      : SizeConfig.blockSizeHorizontal! * 1,
            ),
          ],
          Text(
            buttonText,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

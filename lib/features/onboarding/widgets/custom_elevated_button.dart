import 'package:auto_size_text/auto_size_text.dart';
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
  });

  final void Function()? onPressed;
  final String buttonText;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool? showIcon;
  final String? iconPath;
  final bool? isOutlineButton;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: Size(
          width ?? double.infinity,
          height ?? SizeConfig.blockSizeVertical! * 6,
        ),
        backgroundColor:
            isOutlineButton != null ? Color(whiteColor) : Color(blueColor),
        elevation: 0,
        foregroundColor:
            isOutlineButton != null ? Color(blueColor) : Color(whiteColor),

        shape: RoundedRectangleBorder(
          side:
              isOutlineButton != null
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
          showIcon != null
              ? SvgPicture.asset(
                iconPath ?? googleImage,
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 3
                        : SizeConfig.blockSizeHorizontal! * 5,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 3
                        : SizeConfig.blockSizeVertical! * 5,
              )
              : SizedBox.shrink(),
          SizedBox(
            width:
                showIcon != null
                    ? (SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 2
                        : SizeConfig.blockSizeHorizontal! * 1)
                    : 0,
          ),
          AutoSizeText(
            buttonText,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

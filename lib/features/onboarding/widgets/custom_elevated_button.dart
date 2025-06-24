import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
  });

  final void Function()? onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(
          width ?? double.infinity,
          height ?? SizeConfig.blockSizeVertical! * 6,
        ),
        backgroundColor: Color(blueColor),
        foregroundColor: Color(whiteColor),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? SizeConfig.blockSizeHorizontal! * 3,
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBackButton extends StatelessWidget {
  final Function()? onTap;
  const CustomBackButton({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap:
          onTap ??
          () {
            // Close the keyboard if it's open
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            }
            Navigator.pop(context);
          },
      child: SvgPicture.asset(
        backButtonImage,
        height: SizeConfig.blockSizeHorizontal! * 2,
        width: SizeConfig.blockSizeHorizontal! * 0.2,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

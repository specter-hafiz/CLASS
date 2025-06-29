import 'package:class_app/core/constants/app_colors.dart'
    show blackColor, blueColor;
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class StackContainer extends StatelessWidget {
  const StackContainer({super.key, this.bottomDisplacement, this.color});
  final double? bottomDisplacement;
  final int? color;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomDisplacement ?? -SizeConfig.blockSizeHorizontal! * 3,
      child: Container(
        width:
            SizeConfig.orientation(context) == Orientation.portrait
                ? SizeConfig.blockSizeHorizontal! * 20
                : SizeConfig.blockSizeHorizontal! * 20,
        height:
            SizeConfig.orientation(context) == Orientation.portrait
                ? SizeConfig.blockSizeHorizontal! * 20
                : SizeConfig.blockSizeHorizontal! * 10,
        decoration: BoxDecoration(
          color: Color(color ?? blueColor),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal! * 3),
            bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal! * 3),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(blackColor).withValues(alpha: 0.2),
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}

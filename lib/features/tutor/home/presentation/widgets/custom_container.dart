import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.titleText,
    required this.subText,
    this.iconPath,
    this.showTrailingIcon,
    this.onTap,
    this.onMoreTap,
    this.onMoreButton,
  });
  final String titleText;
  final String subText;
  final String? iconPath;
  final bool? showTrailingIcon;
  final void Function()? onTap;
  final Function(String value)? onMoreTap;
  final List<PopupMenuEntry<String>> Function(BuildContext)? onMoreButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height:
            SizeConfig.orientation(context) == Orientation.portrait
                ? SizeConfig.blockSizeVertical! * 8
                : SizeConfig.blockSizeHorizontal! * 10,
        margin: EdgeInsets.only(
          bottom:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 1
                  : SizeConfig.blockSizeVertical! * 2,
        ),
        padding: EdgeInsets.all(
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeHorizontal! * 2
              : SizeConfig.blockSizeHorizontal! * 1,
        ),
        decoration: BoxDecoration(
          color: Color(lightBlue),
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeHorizontal! * 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal! * 2,
              ),
              child: SvgPicture.asset(
                iconPath ?? documentImage,
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 5
                        : SizeConfig.blockSizeHorizontal! * 12,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 5
                        : SizeConfig.blockSizeVertical! * 12,
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.04
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      subText,

                      style: TextStyle(
                        color: Color(blueColor),
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.04
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            if (showTrailingIcon == true && onMoreButton != null)
              PopupMenuButton<String>(
                iconColor: Color(blueColor),
                color: Colors.white,

                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => onMoreButton!(context),
                onSelected: (value) {
                  if (onMoreTap != null) onMoreTap!(value);
                },
              )
            else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

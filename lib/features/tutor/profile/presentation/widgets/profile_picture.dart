import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 0.8
                  : SizeConfig.blockSizeVertical! * 0.8,
            ),
            decoration: BoxDecoration(
              color: Color(whiteColor),
              border: Border.all(
                color: Color(blueColor),
                width: SizeConfig.blockSizeVertical! * 0.5,
              ),
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeVertical! * 50,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeVertical! * 50,
              ),
              child: Image.asset(
                'assets/images/image.png',
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.5
                        : SizeConfig.screenWidth! * 0.15,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.5
                        : SizeConfig.screenWidth! * 0.15,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 0.5
                    : SizeConfig.blockSizeHorizontal! * 0.2,
            right:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 0.5
                    : SizeConfig.blockSizeHorizontal! * 0.2,
            child: IconButton.filled(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(blueColor)),
              ),
              color: Color(whiteColor),
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}

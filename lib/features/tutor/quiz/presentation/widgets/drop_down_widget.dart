import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropDownTextField extends StatelessWidget {
  const CustomDropDownTextField({
    super.key,
    required TextEditingController controller,
    required List<String> options,
    required this.label,
    this.hintText,
  }) : _controller = controller,
       _options = options;

  final TextEditingController _controller;
  final List<String> _options;
  final String label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.screenWidth! * 0.05
                    : SizeConfig.screenWidth! * 0.02,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
        TextFormField(
          controller: _controller,
          readOnly: true, // Prevent text input
          cursorColor: Color(blueColor),

          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Color(hintColor),
              fontSize:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 5
                      : SizeConfig.blockSizeHorizontal! * 3,
            ),
            isDense: true,
            hintText: hintText,
            suffixIcon: PopupMenuButton<String>(
              icon: SvgPicture.asset(
                arrowDownImage,
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 8
                        : SizeConfig.blockSizeVertical! * 5,
              ),
              onSelected: (String value) {
                _controller.text = value; // Set selected value to the field
              },
              itemBuilder: (BuildContext context) {
                return _options.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 2
                    : SizeConfig.blockSizeHorizontal! * 1,
              ),
              borderSide: BorderSide(color: Color(blueColor), width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 2
                    : SizeConfig.blockSizeHorizontal! * 1,
              ),
              borderSide: BorderSide(color: Color(greyColor), width: 1.0),
            ),

            contentPadding: EdgeInsets.symmetric(
              horizontal:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.horizontalPadding(context)
                      : SizeConfig.horizontalPadding(context) * 0.5,
              vertical: SizeConfig.blockSizeVertical! * 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

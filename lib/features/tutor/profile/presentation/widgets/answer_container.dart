import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class AnswerContainer extends StatelessWidget {
  const AnswerContainer({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
    required this.answerText,
    this.correctIndex,
  });

  final int index;
  final int selectedIndex;
  final String answerText;
  final ValueChanged<int> onChanged;
  final int? correctIndex;
  Color? getBackgroundColor() {
    if (correctIndex != null) {
      if (selectedIndex == index && selectedIndex != correctIndex) {
        return Colors.red; // Wrong answer
      } else if (selectedIndex == index && selectedIndex == correctIndex) {
        return Color(blueColor); // Correct selection
      }
    }
    return selectedIndex == index ? Color(blueColor) : null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return InkWell(
      onTap: () => onChanged(index),
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical! * 1),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical! * 1,
          horizontal: SizeConfig.blockSizeHorizontal! * 3,
        ),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeHorizontal! * 2,
          ),
          border: Border.all(
            color:
                selectedIndex == index ? Colors.transparent : Color(greyColor),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                answerText,
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal! * 4
                          : SizeConfig.blockSizeVertical! * 4,
                  color:
                      selectedIndex == index
                          ? Color(whiteColor)
                          : Color(blackColor),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
            Radio<int>(
              value: index,
              groupValue: selectedIndex,
              onChanged: (_) => onChanged(index),
              activeColor: Color(whiteColor),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Color(whiteColor);
                }
                return Color(greyColor);
              }),

              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

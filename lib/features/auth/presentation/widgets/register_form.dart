import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/continue_with_widget.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          showTitle: true,
          titleText: userNameText,
          hintText: userNameHintText,
          showSuffixIcon: false,
          controller: TextEditingController(),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),
        CustomTextField(
          showTitle: true,
          titleText: emailText,
          hintText: emailHintText,
          showSuffixIcon: false,
          controller: TextEditingController(),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),

        CustomTextField(
          showTitle: true,

          titleText: passwordText,
          hintText: passwordHintText,
          showSuffixIcon: true,
          obscureText: true,
          controller: TextEditingController(),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),
        Row(
          children: [
            // checkbox for terms and conditions
            CustomCheckBox(),
            SizedBox(width: SizeConfig.blockSizeHorizontal! * 0.5),
            RichTextWidget(
              text: "I agree to the ",
              actionText: "Terms and Privacy Policy",
              onTap: () {
                // Handle terms and privacy policy tap
              },
            ),
          ],
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),

        CustomElevatedButton(
          buttonText: registerText,
          onPressed: () {},
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 6
                  : SizeConfig.blockSizeHorizontal! * 5,
          borderRadius:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeHorizontal! * 3
                  : SizeConfig.blockSizeHorizontal! * 1,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),
        ContinueWithWidget(),
        SizedBox(height: SizeConfig.blockSizeVertical! * 1),
        CustomElevatedButton(
          buttonText: "Google",
          showIcon: true,
          onPressed: () {},
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 6
                  : SizeConfig.blockSizeHorizontal! * 5,
          borderRadius:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeHorizontal! * 3
                  : SizeConfig.blockSizeHorizontal! * 1,
        ),
      ],
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key, this.onChanged});
  final void Function(bool?)? onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  var isChecked = false;
  void toggleCheckbox(bool? value) {
    setState(() {
      // Update the checkbox state
      isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Color(blueColor),
      checkColor: Color(whiteColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      value: isChecked,
      onChanged: (value) {
        toggleCheckbox(value);
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: passwordHintText,
            controller: _passwordController,
            showTitle: true,
            showSuffixIcon: true,
            titleText: passwordText,
            obscureText: true,
            focusNode: _passwordFocus,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 2),
          CustomTextField(
            hintText: passwordHintText,
            controller: _confirmPasswordController,
            showTitle: true,
            showSuffixIcon: true,
            titleText: confirmPasswordText,
            obscureText: true,
            focusNode: _confirmPasswordFocus,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 3),
          CustomElevatedButton(
            buttonText: resetPasswordText,
            onPressed: () {
              // Handle reset logic here
            },
            height:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 6
                    : SizeConfig.blockSizeHorizontal! * 5,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 2),
        ],
      ),
    );
  }
}

import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        // Scroll to field when it's focused
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.4,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
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
            controller: _emailController,
            focusNode: _emailFocusNode,
            hintText: "johndoe@mail.com",
            showTitle: true,
            titleText: emailText,
            showSuffixIcon: false,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 2),
          CustomElevatedButton(
            buttonText: sendCodeText,
            height:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 6
                    : SizeConfig.blockSizeHorizontal! * 5,
            borderRadius:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 3
                    : SizeConfig.blockSizeHorizontal! * 1,
            onPressed: () {
              Navigator.pushNamed(context, '/verifyOtp');
            },
          ),
        ],
      ),
    );
  }
}

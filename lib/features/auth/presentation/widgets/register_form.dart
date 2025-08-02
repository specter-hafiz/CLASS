import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/continue_with_widget.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController userNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final FocusNode userNameFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    userNameFocusNode.addListener(
      () => _scrollIntoViewIfNeeded(userNameFocusNode),
    );
    emailFocusNode.addListener(() => _scrollIntoViewIfNeeded(emailFocusNode));
    passwordFocusNode.addListener(
      () => _scrollIntoViewIfNeeded(passwordFocusNode),
    );
    super.dispose();
  }

  void _scrollIntoViewIfNeeded(FocusNode node) {
    if (node.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.4,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              showTitle: true,
              titleText: userNameText,
              hintText: userNameHintText,
              showSuffixIcon: false,
              controller: userNameController,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 1),
            CustomTextField(
              showTitle: true,
              titleText: emailText,
              hintText: emailHintText,
              showSuffixIcon: false,
              controller: emailController,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 1),

            CustomTextField(
              showTitle: true,

              titleText: passwordText,
              hintText: passwordHintText,
              showSuffixIcon: true,
              obscureText: true,
              controller: passwordController,
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

            state is AuthLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                  buttonText: registerText,
                  onPressed: () {
                    // Trigger the registration event
                    context.read<AuthBloc>().add(
                      RegisterRequested(
                        userNameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      ),
                    );
                  },
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
      },
      listener: (BuildContext context, AuthState state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          Navigator.pushNamed(
            context,
            '/verifyOtp',
            arguments: state.email,
          ); // Navigate to OTP verification screen
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
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

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool agreedToTerms = false;

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
    super.dispose();
  }

  void _launchUrl() async {
    Uri url = Uri.parse(AppSecrets.policyDocument);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (!agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must agree to the Terms and Privacy Policy'),
          ),
        );
        return;
      }
      FocusScope.of(context).unfocus(); // dismiss keyboard

      context.read<AuthBloc>().add(
        RegisterRequested(
          userNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      VerifyOTPScreen(email: emailController.text.trim()),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                showSuffixIcon: false,
                readOnly: state is AuthLoading,
                focusNode: userNameFocusNode,
                showTitle: true,
                titleText: userNameText,
                hintText: userNameHintText,
                controller: userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username required';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
                onFieldSubmitted:
                    (_) => FocusScope.of(context).requestFocus(emailFocusNode),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              CustomTextField(
                showSuffixIcon: false,
                readOnly: state is AuthLoading,
                focusNode: emailFocusNode,
                showTitle: true,
                titleText: emailText,
                hintText: emailHintText,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return emailRequiredText;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return invalidEmailText;
                  }
                  return null;
                },
                onFieldSubmitted:
                    (_) =>
                        FocusScope.of(context).requestFocus(passwordFocusNode),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              CustomTextField(
                showTitle: true,
                focusNode: passwordFocusNode,
                titleText: passwordText,
                hintText: passwordHintText,
                showSuffixIcon: true,
                obscureText: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _register(),
                readOnly: state is AuthLoading,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              Row(
                children: [
                  CustomCheckBox(
                    value: agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 0.5),
                  RichTextWidget(
                    text: "I agree to the ",
                    actionText: "Terms and Privacy Policy",
                    onTap: _launchUrl,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              state is AuthLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                    buttonText: registerText,
                    onPressed: _register,
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
            ],
          ),
        );
      },
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Color(blueColor),
      checkColor: Color(whiteColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      value: value,
      onChanged: onChanged,
    );
  }
}

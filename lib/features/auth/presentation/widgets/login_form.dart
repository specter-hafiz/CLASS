import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/screens/verify_otp_screen.dart'
    show VerifyOTPScreen;
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _emailFocusNode.addListener(() => _scrollIntoViewIfNeeded(_emailFocusNode));
    _passwordFocusNode.addListener(
      () => _scrollIntoViewIfNeeded(_passwordFocusNode),
    );
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                showTitle: true,
                titleText: emailText,
                hintText: emailHintText,
                showSuffixIcon: false,
                controller: _emailController,
                focusNode: _emailFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emailRequiredText;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return invalidEmailText;
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),

              CustomTextField(
                showTitle: true,
                titleText: passwordText,
                hintText: passwordHintText,
                showSuffixIcon: true,
                obscureText: true,
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap:
                        () => Navigator.pushNamed(context, '/forgotPassword'),
                    child: Text(
                      forgotPasswordText,
                      style: TextStyle(
                        color: Color(blueColor),
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.04
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.blockSizeVertical! * 1),

              state is AuthLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                    buttonText: loginText,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          LoginRequested(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          ),
                        );
                      }
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
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is RequireOtpVerification) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => VerifyOTPScreen(email: _emailController.text),
            ),
          );
        } else if (state is AuthAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/base', (route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }
}

import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener:
          (context, state) => {
            if (state is ForgotPasswordSuccess)
              {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => VerifyOTPScreen(
                          email: state.email,
                          forgotPassword: true,
                        ),
                  ),
                ),
              }
            else if (state is ForgotPasswordError)
              {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message))),
              },
          },
      builder: (context, state) {
        return Form(
          key: _formKey,

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emailRequiredText;
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return invalidEmailText;
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              state is ForgotPasswordStarting
                  ? Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
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
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      context.read<AuthBloc>().add(
                        ForgotPasswordRequested(
                          email: _emailController.text.trim(),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}

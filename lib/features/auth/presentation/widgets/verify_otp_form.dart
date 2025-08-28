import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOTPForm extends StatefulWidget {
  const VerifyOTPForm({super.key, required this.email, this.forgotPassword});
  final String email;
  final bool? forgotPassword;

  @override
  State<VerifyOTPForm> createState() => VerifyOTPFormState();
}

class VerifyOTPFormState extends State<VerifyOTPForm> {
  final int _otpLength = 5;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _controllers = List.generate(_otpLength, (_) => TextEditingController());

    // Autofocus first field when screen opens:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var f in _focusNodes) {
      f.dispose();
    }
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index, BuildContext context, String email) {
    print("Email in _onChange Function is $email");
    if (value.length == 1 && index < _otpLength - 1) {
      // move to next
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      // back to previous
      _focusNodes[index - 1].requestFocus();
    }

    // check if all boxes are filled
    bool allFilled = _controllers.every((c) => c.text.isNotEmpty);
    if (allFilled) {
      FocusScope.of(context).requestFocus(FocusNode());

      final otp = _controllers.map((c) => c.text).join();
      context.read<AuthBloc>().add(
        VerifyTokenRequested(
          email,
          otp,
          widget.forgotPassword == true ? false : true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double boxWidth =
        SizeConfig.orientation(context) == Orientation.portrait
            ? SizeConfig.screenWidth! * 0.16
            : SizeConfig.screenWidth! * 0.12;
    double boxHeight =
        SizeConfig.orientation(context) == Orientation.portrait
            ? SizeConfig.screenHeight! * 0.08
            : SizeConfig.screenHeight! * 0.2;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is TokenVerified) {
          if (widget.forgotPassword == true) {
            Navigator.pushNamed(
              context,
              '/resetPassword',
              arguments: {'email': widget.email},
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/base',
              (route) => false,
            );
          }
        }

        if (state is ResendOTPSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (i) {
                  return SizedBox(
                    height: boxHeight,
                    width: boxWidth,
                    child: TextFormField(
                      readOnly:
                          state is AuthLoading || state is ResendingOTPState,
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      autofocus: i == 0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.06
                                : SizeConfig.screenWidth! * 0.04,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal! * 2,
                          ),
                          borderSide: BorderSide(
                            color: Color(greyColor), // Grey border
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal! * 2,
                          ),
                          borderSide: BorderSide(
                            color: Color(blueColor), // Primary color border
                          ),
                        ),
                      ),

                      onChanged:
                          (value) =>
                              _onChanged(value, i, context, widget.email),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 3),

            state is AuthLoading
                ? Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                  buttonText: verifyText,
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 6
                          : SizeConfig.blockSizeHorizontal! * 5,
                  onPressed:
                      state is ResendingOTPState
                          ? null
                          : () {
                            if (_controllers.any((c) => c.text.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill all OTP fields'),
                                ),
                              );
                              return;
                            }
                            //close the keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            final otp = _controllers.map((c) => c.text).join();
                            context.read<AuthBloc>().add(
                              VerifyTokenRequested(
                                widget.email,
                                otp,
                                widget.forgotPassword == true ? false : true,
                              ),
                            );
                          },
                ),
            // Add your custom text field for email input here
            SizedBox(height: SizeConfig.blockSizeVertical! * 3),
            state is ResendingOTPState
                ? Center(child: CircularProgressIndicator())
                : RichTextWidget(
                  text: didntReceiveCodeText,
                  actionText: resendText,
                  onTap:
                      state is AuthLoading
                          ? null
                          : () {
                            context.read<AuthBloc>().add(
                              ResendOTPRequested(widget.email),
                            );
                          },
                ),
          ],
        );
      },
    );
  }
}

import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/register_form.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    Center(
                      child: Image.asset(
                        logoImage,
                        height:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenHeight! * 0.15
                                : SizeConfig.screenHeight! * 0.2,
                        width: SizeConfig.screenWidth! * 0.2,
                      ),
                    ),

                    Text(
                      registerText,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.09
                                : SizeConfig.screenWidth! * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                    Text(
                      registerToContinueText,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.05
                                : SizeConfig.screenWidth! * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                    // Registration form widget goes here
                    RegisterForm(),

                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    RichTextWidget(
                      text: "Already have an account? ",
                      actionText: loginText,
                      onTap:
                          state is AuthLoading
                              ? null
                              : () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                    ),
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizedBox.shrink()
                        : SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

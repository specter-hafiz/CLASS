import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/continue_with_widget.dart';
import 'package:class_app/features/auth/presentation/widgets/login_form.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger native Google account picker
      await GoogleSignIn.instance.initialize(
        clientId: AppSecrets.googleClientId,
        serverClientId: AppSecrets.googleWebClientId,
      );
      GoogleSignInAccount account = await GoogleSignIn.instance.authenticate(
        scopeHint: [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      GoogleSignInAuthentication googleAuth = account.authentication;
      if (googleAuth.idToken != null) {
        final idToken = googleAuth.idToken; // ✅ Send this to backend
        context.read<AuthBloc>().add(LoginWithGoogleRequested(id: idToken!));
      }
    } catch (e) {
      // Handle error, e.g., show a snackbar or dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GoogleLoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/base', (route) => false);
        }
      },
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
                    SizedBox(height: SizeConfig.screenHeight! * 0.05),
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
                    SizedBox(height: SizeConfig.blockSizeVertical! * 1),

                    Text(
                      loginText,
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
                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    Text(
                      loginToContinueText,
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
                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),

                    AbsorbPointer(
                      absorbing: state is GoogleLoggingInState,
                      child: LoginForm(),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    ContinueWithWidget(),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    CustomElevatedButton(
                      buttonText:
                          state is GoogleLoggingInState
                              ? "Logging in..."
                              : "Google",
                      showIcon: true,
                      onPressed:
                          state is GoogleLoggingInState
                              ? null
                              : () => signInWithGoogle(context),
                      height:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 6
                              : SizeConfig.blockSizeHorizontal! * 5,
                      borderRadius:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 3
                              : SizeConfig.blockSizeHorizontal! * 1,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                    RichTextWidget(
                      text: "Don't have an account? ",
                      actionText: registerText,
                      onTap:
                          state is AuthLoading
                              ? null
                              : () {
                                FocusScope.of(context).unfocus();

                                Navigator.pushNamed(context, '/register');
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

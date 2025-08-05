import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text(
          changePasswordText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 6
                    : SizeConfig.blockSizeVertical! * 7,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is ChangePasswordError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: passwordHintText,
                      titleText: oldPasswordText,
                      controller: oldPasswordController,
                      showTitle: true,
                      showSuffixIcon: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 2
                              : SizeConfig.blockSizeHorizontal! * 2,
                    ),
                    CustomTextField(
                      hintText: passwordHintText,
                      titleText: newPasswordText,
                      controller: newPasswordController,
                      showTitle: true,
                      showSuffixIcon: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 2
                              : SizeConfig.blockSizeHorizontal! * 2,
                    ),
                    state is ChangingPassword
                        ? Center(child: CircularProgressIndicator())
                        : CustomElevatedButton(
                          buttonText: changePasswordText,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (oldPasswordController.text ==
                                  newPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'New password cannot be the same as old password',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final user =
                                  await sl<SharedPrefService>().getUser();
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'User not found. Please log in again.',
                                    ),
                                  ),
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                                return;
                              }
                              // Process the change password request
                              context.read<AuthBloc>().add(
                                ChangePasswordRequested(
                                  user.id,
                                  oldPasswordController.text.trim(),
                                  newPasswordController.text.trim(),
                                ),
                              );
                            }
                          },
                        ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

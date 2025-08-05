import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  String? _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('email')) {
      _email = args['email'];
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener:
          (context, state) => {
            if (state is ResetPasswordSuccess)
              {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message))),
              }
            else if (state is ResetPasswordError)
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
                hintText: passwordHintText,
                controller: _passwordController,
                showTitle: true,
                showSuffixIcon: true,
                titleText: passwordText,
                obscureText: true,
                focusNode: _passwordFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return passwordRequiredText;
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return passwordRequiredText;
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 3),
              state is ResetPasswordStarting
                  ? Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                    buttonText: resetPasswordText,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          ResetPasswordRequested(
                            email: _email ?? '',
                            newPassword: _confirmPasswordController.text.trim(),
                          ),
                        );
                      }
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
      },
    );
  }
}

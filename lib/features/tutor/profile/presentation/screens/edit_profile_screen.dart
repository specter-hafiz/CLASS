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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController userNameController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    setUserName();
  }

  void setUserName() async {
    final user = await sl<SharedPrefService>().getUser();
    if (user != null) {
      userNameController.text = user.name;
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        centerTitle: true,
        title: Text(
          editProfileText,
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
            listener: (context, state) async {
              if (state is EditProfileSuccess) {
                final currentUser = await sl<SharedPrefService>().getUser();
                if (currentUser == null) return;
                final user = currentUser.copyWith(
                  name: userNameController.text.trim(),
                );
                await sl<SharedPrefService>().saveUser(user);
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                if (!mounted) return;
                Navigator.pop(context);
              } else if (state is EditProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                    hintText: userNameHintText,
                    titleText: userNameText,
                    controller: userNameController,
                    showTitle: true,
                    showSuffixIcon: true,
                  ),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 2
                            : SizeConfig.blockSizeHorizontal! * 2,
                  ),
                  state is EditProfileStarting
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                        buttonText: saveText,
                        onPressed: () {
                          final name = userNameController.text.trim();
                          if (name.isEmpty || name.length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Username must be at least 3 characters',
                                ),
                              ),
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                            EditProfileRequested(name),
                          );
                        },
                      ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

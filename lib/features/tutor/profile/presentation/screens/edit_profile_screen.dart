import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
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
          child: BlocBuilder<AuthBloc, AuthState>(
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
                    controller: TextEditingController(),
                    showTitle: true,
                    showSuffixIcon: true,
                  ),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 2
                            : SizeConfig.blockSizeHorizontal! * 2,
                  ),

                  CustomElevatedButton(buttonText: saveText, onPressed: () {}),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

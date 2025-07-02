import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class EditTranscriptScreen extends StatelessWidget {
  const EditTranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          editTrancriptText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 2.5
                    : SizeConfig.blockSizeVertical! * 6,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            iconSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 3
                    : SizeConfig.blockSizeVertical! * 8,
            onPressed: () {
              // Handle save action
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: SizedBox(
          child: TextField(
            maxLines: null,
            controller: TextEditingController(
              text:
                  "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            ),
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

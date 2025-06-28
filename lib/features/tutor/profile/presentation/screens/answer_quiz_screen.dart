import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnswerQuizScreen extends StatelessWidget {
  const AnswerQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isPortrait = SizeConfig.orientation(context) == Orientation.portrait;
    final screenHeight =
        SizeConfig.screenHeight ?? MediaQuery.of(context).size.height;
    final screenWidth =
        SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:
            isPortrait
                ? Text(
                  "01/100",
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal! * 6,
                    fontWeight: FontWeight.w600,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      buttonText: backText,
                      isOutlineButton: true,
                      onPressed: () {},
                      width: screenWidth * 0.2,
                    ),
                    Text(
                      "01/100",
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    CustomElevatedButton(
                      buttonText: nextText,
                      onPressed: () {},
                      width: screenWidth * 0.2,
                    ),
                  ],
                ),
        actionsPadding: EdgeInsets.only(
          right: SizeConfig.horizontalPadding(context),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isPortrait
                      ? SizeConfig.blockSizeHorizontal! * 2
                      : SizeConfig.blockSizeHorizontal! * 1,
            ),
            decoration: BoxDecoration(
              color: Color(blueColor),
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeHorizontal! * 3,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  timerImage,
                  width:
                      isPortrait
                          ? SizeConfig.blockSizeHorizontal! * 4
                          : SizeConfig.blockSizeHorizontal! * 2,
                  height:
                      isPortrait
                          ? SizeConfig.blockSizeHorizontal! * 4
                          : SizeConfig.blockSizeHorizontal! * 2,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal! * 1),
                Text(
                  "00:10:30",
                  style: TextStyle(
                    fontSize:
                        isPortrait
                            ? SizeConfig.blockSizeHorizontal! * 4
                            : SizeConfig.blockSizeHorizontal! * 2,
                    color: Color(whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          SizeConfig.blockSizeVertical! *
                          (SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? 6
                              : 2),
                    ),
                    QuizCard(),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 6),
                  ],
                ),
              ),
            ),
            if (isPortrait)
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: backText,
                      onPressed: () {},
                      isOutlineButton: true,
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: nextText,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        StackContainer(
          bottomDisplacement:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? (-SizeConfig.blockSizeHorizontal! * 6)
                  : (-SizeConfig.blockSizeHorizontal! * 3),
          color: hospitalBlue,
        ),
        StackContainer(
          bottomDisplacement:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? (-SizeConfig.blockSizeHorizontal! * 3)
                  : (-SizeConfig.blockSizeHorizontal! * 1.5),
        ),
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal! * 3),
          decoration: BoxDecoration(
            color: Color(whiteColor),
            borderRadius: BorderRadius.circular(
              SizeConfig.blockSizeHorizontal! * 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(blackColor).withValues(alpha: 0.4),
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionWidget(),
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? AnswersWidget()
                          : SizedBox.shrink(),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: QuestionWidget()),
                      SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                      Expanded(child: AnswersWidget()),
                    ],
                  ),
        ),
      ],
    );
  }
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Question",
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 5
                    : SizeConfig.blockSizeVertical! * 5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
        Text(
          "If it takes 5 hours for 5 men to dig 5 holes, how long does it take for 100 men to dig 100 holes?",
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 5
                    : SizeConfig.blockSizeVertical! * 5,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 3),
      ],
    );
  }
}

class StackContainer extends StatelessWidget {
  const StackContainer({super.key, this.bottomDisplacement, this.color});
  final double? bottomDisplacement;
  final int? color;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomDisplacement ?? -SizeConfig.blockSizeHorizontal! * 3,
      child: Container(
        width:
            SizeConfig.orientation(context) == Orientation.portrait
                ? SizeConfig.blockSizeHorizontal! * 20
                : SizeConfig.blockSizeHorizontal! * 20,
        height:
            SizeConfig.orientation(context) == Orientation.portrait
                ? SizeConfig.blockSizeHorizontal! * 20
                : SizeConfig.blockSizeHorizontal! * 10,
        decoration: BoxDecoration(
          color: Color(color ?? blueColor),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal! * 3),
            bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal! * 3),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(blackColor).withValues(alpha: 0.4),
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}

class AnswersWidget extends StatefulWidget {
  const AnswersWidget({super.key});

  @override
  State<AnswersWidget> createState() => _AnswersWidgetState();
}

class _AnswersWidgetState extends State<AnswersWidget> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4, // Example options count
      itemBuilder: (context, index) {
        return AnswerContainer(
          index: index,
          selectedIndex: selectedIndex, // Replace with actual selected index
          onChanged: (i) {
            // Handle selection change
            setState(() {
              selectedIndex = i;
            });
          },
        );
      },
    );
  }
}

class AnswerContainer extends StatelessWidget {
  const AnswerContainer({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int index;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return InkWell(
      onTap: () => onChanged(index),
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical! * 1),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical! * 1,
          horizontal: SizeConfig.blockSizeHorizontal! * 3,
        ),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Color(blueColor) : null,
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeHorizontal! * 2,
          ),
          border: Border.all(
            color:
                selectedIndex == index ? Colors.transparent : Color(greyColor),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Option ${index + 1} ",
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal! * 4
                          : SizeConfig.blockSizeVertical! * 4,
                  color:
                      selectedIndex == index
                          ? Color(whiteColor)
                          : Color(blackColor),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
            Radio<int>(
              value: index,
              groupValue: selectedIndex,
              onChanged: (_) => onChanged(index),
              activeColor: Color(whiteColor),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Color(whiteColor);
                }
                return Color(greyColor);
              }),

              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

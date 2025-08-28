import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.titleText,
    required this.controller,
    required this.showTitle,
    this.obscureText,
    required this.showSuffixIcon,
    this.maxLines,
    this.focusNode,
    this.readOnly,
    this.underlineInputBorder,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType,
  });
  final String hintText;
  final String? titleText;
  final TextEditingController controller;
  final bool showTitle;
  final bool? obscureText;
  final bool showSuffixIcon;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? readOnly;
  final bool? underlineInputBorder;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  void toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(
              widget.titleText ?? "",
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.05
                        : SizeConfig.screenWidth! * 0.02,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            )
            : SizedBox.shrink(),
        widget.showTitle
            ? SizedBox(height: SizeConfig.blockSizeVertical! * 1)
            : SizedBox.shrink(),
        TextFormField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: widget.readOnly ?? false,

          focusNode: widget.focusNode,
          maxLines: widget.maxLines ?? 1,
          controller: widget.controller,
          obscureText: (widget.obscureText ?? false) ? _obscureText : false,

          decoration: InputDecoration(
            isDense: true,
            suffixIconConstraints: BoxConstraints(
              minHeight:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 3
                      : SizeConfig.blockSizeVertical! * 5,
              minWidth:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 4
                      : SizeConfig.blockSizeHorizontal! * 6,
            ),

            suffixIcon:
                widget.showSuffixIcon
                    ? InkWell(
                      onTap: () {
                        if (widget.obscureText != null) {
                          toggleVisibility();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal! * 4,
                        ),
                        child:
                            _obscureText
                                ? SvgPicture.asset('assets/svgs/eye.svg')
                                : SvgPicture.asset(
                                  'assets/svgs/eye_open.svg',
                                  colorFilter: ColorFilter.mode(
                                    Color(blueColor),
                                    BlendMode.srcIn,
                                  ),
                                ),
                      ),
                    )
                    : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Color(hintColor).withValues(alpha: 0.3),
              fontSize:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 5
                      : SizeConfig.blockSizeHorizontal! * 3,
            ),
            focusedBorder:
                widget.underlineInputBorder != null
                    ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(blueColor),
                        width: 1.0,
                      ),
                    )
                    : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal! * 2
                            : SizeConfig.blockSizeHorizontal! * 1,
                      ),
                      borderSide: BorderSide(
                        color: Color(blueColor),
                        width: 1.0,
                      ),
                    ),
            border:
                widget.underlineInputBorder != null
                    ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(blueColor),
                        width: 1.0,
                      ),
                    )
                    : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal! * 2
                            : SizeConfig.blockSizeHorizontal! * 1,
                      ),
                      borderSide: BorderSide(
                        color: Color(greyColor),
                        width: 1.0,
                      ),
                    ),

            contentPadding: EdgeInsets.symmetric(
              horizontal:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? (widget.underlineInputBorder != null
                          ? SizeConfig.horizontalPadding(context) / 2
                          : SizeConfig.horizontalPadding(context))
                      : SizeConfig.horizontalPadding(context) * 0.5,
              vertical: SizeConfig.blockSizeVertical! * 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

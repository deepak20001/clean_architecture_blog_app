import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLine;

  const CommonText({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = AppPallete.whiteColor,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLine,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

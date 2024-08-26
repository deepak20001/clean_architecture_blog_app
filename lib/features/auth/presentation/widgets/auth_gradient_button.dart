import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * numD018),
        gradient: const LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(size.width, size.width * numD15),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: CommonText(
          title: buttonText,
          fontSize: size.width * numD04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

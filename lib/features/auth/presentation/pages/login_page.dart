import 'package:blog_app/core/common/widgets/common_space.dart';
import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(size.width * numD035),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                title: '${Constants.signIn}.',
                fontSize: size.width * numD1,
                fontWeight: FontWeight.bold,
              ),
              verticalSpace(size.width * numD08),
              AuthField(
                hintText: Constants.email,
                controller: _emailController,
              ),
              verticalSpace(size.width * numD035),
              AuthField(
                hintText: Constants.password,
                controller: _passwordController,
                isObscureText: true,
              ),
              verticalSpace(size.width * numD05),
              AuthGradientButton(
                buttonText: Constants.signIn,
                onPressed: () {},
              ),
              verticalSpace(size.width * numD035),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    SignUpPage.route(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: '${Constants.dontHaveAnAccount} ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: Constants.signUp,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

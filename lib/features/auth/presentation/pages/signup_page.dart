import 'package:blog_app/core/common/widgets/common_space.dart';
import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(size.width * numD035),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                title: '${Constants.signUp}.',
                fontSize: size.width * numD1,
                fontWeight: FontWeight.bold,
              ),
              verticalSpace(size.width * numD08),
              AuthField(
                hintText: Constants.name,
                controller: _nameController,
              ),
              verticalSpace(size.width * numD035),
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
              const AuthGradientButton(
                buttonText: Constants.signUp,
              ),
              verticalSpace(size.width * numD035),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    LoginPage.route(),
                    (route) => false,
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: '${Constants.alreadyHaveAnAccount} ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: Constants.signIn,
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

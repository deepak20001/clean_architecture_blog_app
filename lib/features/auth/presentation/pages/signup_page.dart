import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/space.dart';
import 'package:blog_app/core/common/widgets/common_text.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(size.width * numD035),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              return showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
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
                  AuthGradientButton(
                    buttonText: Constants.signUp,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      }
                    },
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
            );
          },
        ),
      ),
    );
  }
}

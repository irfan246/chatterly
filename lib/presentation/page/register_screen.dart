import 'package:chatterly/application/auth/auth_bloc.dart';
import 'package:chatterly/presentation/widget/bottom_curved_clipper.dart';
import 'package:chatterly/presentation/widget/button_custom.dart';
import 'package:chatterly/presentation/widget/custom_text_button.dart';
import 'package:chatterly/presentation/widget/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  RegisterScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: ClipPath(
                clipper: BottomCurvedClipper(),
                child: Material(
                  color: const Color.fromARGB(255, 29, 29, 29),
                  child: Center(
                    child: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFieldCustom(
                      controller: _usernameController,
                      icon: Icons.person,
                      text: 'Username',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      controller: _emailController,
                      icon: Icons.email,
                      text: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      controller: _passwordController,
                      icon: Icons.password,
                      text: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      controller: _confirmPasswordController,
                      icon: Icons.password,
                      text: 'Confirm Password',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ButtonCustom(
                          onTap: () {
                            context.read<AuthBloc>().add(
                                  RegisterEvent(
                                    email: _emailController.text.trim(),
                                    username: _usernameController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    confirmPassword:
                                        _confirmPasswordController.text.trim(),
                                  ),
                                );
                          },
                          text: 'Register',
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextButton(
                      text: 'Have an account?',
                      buttonText: 'Login',
                      onTap: onTap,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

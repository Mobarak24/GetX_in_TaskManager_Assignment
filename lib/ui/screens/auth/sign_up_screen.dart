import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/utility/app_constants.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _registerInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'Join With Us',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your Email";
                        }
                        if (AppConstants.emailRegex.hasMatch(value!) == false) {
                          return "Please Enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(hintText: 'First Name'),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return "Enter your First Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(hintText: 'Last Name'),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return "Enter your Last Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return "Enter your Phone Number";
                        }
                        if (AppConstants.mobileRegex.hasMatch(value!)) {
                          return "Please Enter valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: _showPassword == false,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            _showPassword = !_showPassword;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: _showPassword
                              ? const Icon(Icons.remove_red_eye_rounded)
                              : const Icon(Icons.visibility_off_rounded),
                        ),
                      ),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return "Enter your Password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: _registerInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_sharp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildBackToSignInSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: AppColors.black.withOpacity(0.8)),
          text: "Have account?",
          children: [
            TextSpan(
              style: const TextStyle(color: AppColors.themeColor),
              text: 'Sign in',
              recognizer: TapGestureRecognizer()
                ..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    _registerInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text.trim(),
      "photo": ""
    };
   final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    _registerInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _clearTextField();
      if (mounted) {
        showSnackBarMassage(context, 'Registration Successfully');
      }
    } else {
      if (mounted) {
        showSnackBarMassage(
            context, response.errorMassage ?? 'Registration failed! Try Again');
      }
    }
  }

  void _clearTextField() {
    _emailTEController.clear();
    _passwordTEController.clear();
    _mobileTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _mobileTEController.dispose();
    _lastNameTEController.dispose();
    _firstNameTEController.dispose();
    super.dispose();
  }
}

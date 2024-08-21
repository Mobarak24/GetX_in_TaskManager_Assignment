import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email,otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPassTEController =
      TextEditingController();
  bool _resetPaswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Minimum length of password should be more than 6 letters and, combination of numbers and letters',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPassTEController,
                    decoration:
                        const InputDecoration(hintText: 'Confirm Password'),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: _resetPaswordInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _onConfirmButton,
                      child: const Icon(
                        Icons.arrow_forward_ios_sharp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _buildSingInSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: AppColors.black.withOpacity(0.8)),
          text: "Have account?",
          children: [
            TextSpan(
              style: const TextStyle(color: AppColors.themeColor),
              text: 'Sign in',
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  void _onConfirmButton() {
    _resetPassword(_passwordTEController.text);
  }

  Future<void> _resetPassword(String password) async {
    _resetPaswordInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> inputParams = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": password
    };

    NetworkResponse response =
    await NetworkCaller.postRequest(Urls.resetPassword, body: inputParams);
    _resetPaswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMassage(
            context, response.errorMassage ?? 'Reset Password Success');
      }
      if(mounted){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBarMassage(
            context, response.errorMassage ?? 'Reset Password failed! Try again');
      }
    }

  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPassTEController.dispose();
    super.dispose();
  }
}

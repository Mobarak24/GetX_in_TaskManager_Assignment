import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

import '../screens/auth/sign_in_screen.dart';

AppBar profileAppBar(context, [fromUpdateProfile = false]) {
  return AppBar(
    centerTitle: false,
    backgroundColor: AppColors.themeColor,
    leading: const Padding(
      padding: EdgeInsets.all(6),
      child: CircleAvatar(),
    ),
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (fromUpdateProfile) {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen(),
            ),
          );
        },
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AuthController .userData?.fullName ?? '',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              AuthController.userData?.email ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () async {
            await AuthController.clearAllData();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    ],
  );
}

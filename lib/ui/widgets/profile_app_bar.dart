import 'package:flutter/material.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

AppBar profileAppBar() {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: const Padding(
      padding: EdgeInsets.all(6),
      child: CircleAvatar(),
    ),
    title: const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobarak Hossain',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Text(
            'mobarak@gmail.com',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 24,
            )),
      )
    ],
  );
}

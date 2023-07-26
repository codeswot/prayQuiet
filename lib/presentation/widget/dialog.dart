import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/presentation/shared/context_extension.dart';

import 'package:pray_quiet/presentation/style/style.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.description,
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final String title;
  final String description;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 200.h, horizontal: 30.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          child: Container(
            color: AppColors.primary,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.secondary.withOpacity(0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondary.withOpacity(0.5),
                    radius: 35.sp,
                    child: Icon(
                      Icons.info,
                      color: AppColors.text,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    style: AppTypography.m3TitlelLarge(),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTypography.m3BodylLarge(),
                  ),
                  SizedBox(height: 15.h),
                  ElevatedButton(
                    onPressed: () {
                      onTap?.call();
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

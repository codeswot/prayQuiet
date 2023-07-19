import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension ContextExtensions on BuildContext {
  bool get mounted {
    try {
      widget;
      return true;
    } catch (e) {
      return false;
    }
  }

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  void pop() => Navigator.of(this).pop();

  Future<T?> showAppDialog<T>(Widget dialog) => showDialog<T>(
        useSafeArea: false,
        // barrierDismissible: false,
        context: this,
        builder: (context) => dialog,
      );

  Future<T?> showBottomSheet<T>(Widget sheet) => showModalBottomSheet<T>(
        useRootNavigator: true,
        isScrollControlled: true,
        context: this,
        builder: (context) => sheet,
      );

  Future<void> openWeb(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}

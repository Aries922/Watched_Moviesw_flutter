import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  final BuildContext context;

  AppSnackbar.of(this.context);

  ScaffoldMessengerState get _state {
    return ScaffoldMessenger.of(context);
  }

  void hideAll() {
    _state.removeCurrentSnackBar();
  }

  void _snackbar(
    String message, [
    Color? backgroundColor,
    Color? foregroundColor,
  ]) {
    _state.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: foregroundColor != null
              ? TextStyle(
                  color: foregroundColor,
                )
              : null,
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void success(String message) => _snackbar(
        message,
        Colors.green,
        Colors.white,
      );

  void regular(String message) => _snackbar(message);

  void error(String message) => _snackbar(
        message,
        Colors.red,
        Colors.white,
      );
}

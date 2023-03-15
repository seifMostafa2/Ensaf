import 'package:flutter/material.dart';
import 'package:hokok/core/routes_manager.dart';
import 'package:hokok/core/shared_widget/circler_loader_shared_widget.dart';
import 'package:hokok/core/shared_widget/show_snackbar_shared_widget.dart';

abstract class AuthStates {}

class AuthInitState extends AuthStates {}

class AuthLoadingState extends AuthStates {
  // showLoadingDialog(BuildContext context) async {
  //   return await showCircleLoaderWidget(context);
  // }
}

class AuthSuccessState extends AuthStates {
  Route authNaviation(RouteSettings settings) {
    return RouteGenerator.getRoute(settings);
  }
}

class AuthFailedState extends AuthStates {
  String error;
  AuthFailedState(this.error);

  authErrorMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
        .showSnackBar(showSnakBarWidget(context, title, Colors.red));
  }
}
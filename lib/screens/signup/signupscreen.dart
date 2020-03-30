

import 'package:dota_notifier/blocs/auth-bloc.dart';
import 'package:dota_notifier/screens/signup/signupform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/signup-bloc.dart';

class SignupScreen extends StatelessWidget {

  SignupScreen({Key key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return SignupBloc(
            authenticationBloc: BlocProvider.of<AuthBloc>(context),
          );
        },
        child: SignupForm(),
      ),
    );
  }

}
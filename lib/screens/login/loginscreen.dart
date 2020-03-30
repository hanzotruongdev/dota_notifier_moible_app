import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:dota_notifier/screens/login/bloc/login-bloc.dart';
import 'package:dota_notifier/screens/login/loginform.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dota_notifier/blocs/blocs.dart';


class LoginScreen extends StatelessWidget {

  LoginScreen({Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthBloc>(context),
            firebaseBloc: BlocProvider.of<FirebaseBloc>(context)
          );
        },
        child: LoginForm(),
      ),
    );
  }
}

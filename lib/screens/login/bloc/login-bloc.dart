import 'dart:async';

import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:dota_notifier/services/utils.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:dota_notifier/blocs/blocs.dart';

part 'login-event.dart';
part 'login-state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authenticationBloc;
  FirebaseBloc firebaseBloc;

  LoginBloc({
    @required this.authenticationBloc, this.firebaseBloc
  })  : assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        validateEmail(event.username);
      } catch (error){
        yield LoginFailure(error: error);
        return;
      }

      if (event.password.length == 0) {
        yield LoginFailure(error: "Password is empty!");
        return;
      }

      try {
        final token = await authenticationBloc.userRepository.authenticate(
          email: event.username,
          password: event.password, firebaseToken: firebaseBloc.token
        );

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}

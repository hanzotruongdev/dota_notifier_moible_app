
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dota_notifier/blocs/auth-bloc.dart';
import 'package:dota_notifier/services/utils.dart';
import 'package:flutter/cupertino.dart';

///
/// Event
/// 
abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;
  final String repassword;

  SignupButtonPressed({
    @required this.email,
    @required this.password,
    @required this.repassword,
  });

  List<Object> get props => [email, password, repassword];

  @override
  String toString() =>
      'SignupButtonPressed { email: $email, password: $password, repassword: $repassword }';
}



///
/// State
/// 
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignupFailure { error: $error }';
}


///
/// State
/// 
class SignupBloc extends Bloc <SignupEvent, SignupState> {
  final AuthBloc authenticationBloc;

  SignupBloc({
    @required this.authenticationBloc,
  })  : assert(authenticationBloc != null);

  @override
  SignupState get initialState => SignupInitial();

  

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async * {
    if (event is SignupButtonPressed) {
      yield SignupLoading();

      String email = event.email;
      String password = event.password;
      String repassword = event.repassword;

      try {
        validateEmail(email);
      } catch (error){
        yield SignupFailure(error: error);
        return;
      }

      if (password.length < 6){
        yield SignupFailure(error: "Your password must contain at least 6 characters");
        return;
      }

      if (password.length > 256){
        yield SignupFailure(error: "your password is too long!");
        return;
      }

      if (password != repassword){
        yield SignupFailure(error: "Password do not match!");
        return;
      }

      try {
        await authenticationBloc.userRepository.register(
          email: event.email,
          password: event.password,
        );

        yield SignupInitial();
      } catch (error) {
        yield SignupFailure(error: error.toString());
      }
    }
  }

}
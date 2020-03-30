
import 'package:bloc/bloc.dart';
import 'package:dota_notifier/blocs/auth-bloc.dart';
import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:dota_notifier/services/api.dart';

class Profile {
  int id;
  String email;
  String name;
  bool subscribeAll;

  Profile({this.id, this.email, this.name, this.subscribeAll});

}

///
/// Event
/// 
abstract class ProfileEvent {}

class ProfileFetchStarted extends ProfileEvent {}
class ProfileSignedOut extends ProfileEvent {}
class ProfileChangeSubmited extends ProfileEvent {
  final bool subscribeAll;

  ProfileChangeSubmited({@required this.subscribeAll});
}

///
/// State
///
abstract class ProfileState {
  get profile => null;
}

class ProfileUninitializedState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileFetchedState extends ProfileState {
  Profile profile;

  ProfileFetchedState ({@required this.profile});
}

class ProfileErrorState extends ProfileState {
  String error;

  ProfileErrorState ({@required this.error});
}


///
/// Bloc
/// 
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AuthBloc authBloc;
  FirebaseBloc firebaseBloc;

  Profile profile;

  ProfileBloc({this.authBloc, this.firebaseBloc, this.profile});

  @override
  ProfileState get initialState => ProfileUninitializedState();


  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async *{
    if (event is ProfileFetchStarted) {
      
      try {

        yield ProfileLoadingState();

        var p = await fetchProfile(authBloc.userRepository);
        this.profile = p;

        yield ProfileFetchedState(profile: p);

      }
      catch (error) {
        yield ProfileErrorState(error: error);
      }
    }
    
    else if (event is ProfileChangeSubmited) {
      try {

        yield ProfileLoadingState();

        await updateProfile(authBloc.userRepository, firebaseBloc.token, event.subscribeAll);
        this.profile.subscribeAll = event.subscribeAll;

        yield ProfileFetchedState(profile: this.profile);

      }
      catch (error) {
        yield ProfileErrorState(error: "ProfileChangeSubmited error");
      }
    }
  }

}
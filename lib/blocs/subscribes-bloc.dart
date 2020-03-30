
import 'package:bloc/bloc.dart';
import 'package:dota_notifier/blocs/auth-bloc.dart';
import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:dota_notifier/services/api.dart';
import 'package:flutter/cupertino.dart';

class Channel {
  String accountId;
  Channel({@required this.accountId});
}


///
/// SubscribesEvent
/// 
abstract class SubscribesEvent {}

class SubscribesFetchStarted extends SubscribesEvent {}
class SubscribesSubToPlayerStarted extends SubscribesEvent {
  final String playerId;
  SubscribesSubToPlayerStarted({@required this.playerId});
}
class SubscribesUnsubToPlayerStarted extends SubscribesEvent {
  final String playerId;
  SubscribesUnsubToPlayerStarted({@required this.playerId});
}

///
/// SubscribesState
/// 
abstract class SubscribesState {}

class SubscribesUnitializedState extends SubscribesState {}
class SubscribesLoading extends SubscribesState {}

class SubscribesFetchedState extends SubscribesState {
}
class SubscribesErrorState extends SubscribesState {
  final String error;
  SubscribesErrorState({@required this.error});
}

///
/// Subscribes-Bloc
/// 
class SubscribesBloc extends Bloc<SubscribesEvent, SubscribesState> {
  AuthBloc authBloc;
  FirebaseBloc firebaseBloc;
  List<Channel> list = [];

  SubscribesBloc({this.authBloc, this.firebaseBloc});

  @override
  SubscribesState get initialState => SubscribesUnitializedState();

  @override
  Stream<SubscribesState> mapEventToState(SubscribesEvent event) async* {

    // SubscribesFetchStarted
    if (event is SubscribesFetchStarted) {

      yield SubscribesLoading();
      try {
        this.list = await fetchSubscribes(authBloc.userRepository);
        yield SubscribesFetchedState();
      } catch (error) {
        yield SubscribesErrorState(error: error);
      }
    } 

    // SubscribesSubToPlayerStarted
    else if (event is SubscribesSubToPlayerStarted) {
      try {
        yield SubscribesLoading();
        subscribeToPlayer(authBloc.userRepository, firebaseBloc.token, event.playerId);
        this.list.add(Channel(accountId: event.playerId));
        yield SubscribesFetchedState();
      } catch (error) {
        yield SubscribesErrorState(error: error);
      }
    }  
    
    // SubscribesUnsubToPlayerStarted
    else if (event is SubscribesUnsubToPlayerStarted) {
      try {
        unsubscribeToPlayer(authBloc.userRepository, firebaseBloc.token, event.playerId);
        for (var i = 0; i < this.list.length; i++){
          if (this.list[i].accountId == event.playerId){
            this.list.removeAt(i);
            break;
          }
        }
        yield SubscribesFetchedState();
      } catch (error) {
        yield SubscribesErrorState(error: error);
      }
    }

  }
}
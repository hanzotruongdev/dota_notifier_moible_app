
import 'package:bloc/bloc.dart';
import 'package:dota_notifier/services/api.dart';
import 'package:flutter/cupertino.dart';

class ProPlayer {
  String accountid;
  String steamid;
  String avatarfull;
  String profileurl;
  String personaname;
  String name;
  String countrycode;
  String teamid;
  String teamname;
  String teamtag;
  bool subscribe = false;

  ProPlayer ({this.accountid, this.steamid, this.avatarfull, this.profileurl, this.personaname, this.name, this.countrycode, this.teamid, this.teamname, this.teamtag, this.subscribe = false});
}


///
/// ProPlayersEvent
/// 
abstract class ProPlayersEvent {}

class ProPlayersFetchStarted extends ProPlayersEvent {}

///
/// ProPlayersState
/// 
abstract class ProPlayersState {
  get list => null;
}

class ProPlayersUnitializedState extends ProPlayersState {}
class ProPlayersLoading extends ProPlayersState {}

class ProPlayersFetchedState extends ProPlayersState {
  final List<ProPlayer> list;
  ProPlayersFetchedState({@required this.list});
}
class ProPlayersErrorState extends ProPlayersState {
  final String error;
  ProPlayersErrorState({@required this.error});
}

///
/// ProPlayers-Bloc
/// 
class ProPlayersBloc extends Bloc<ProPlayersEvent, ProPlayersState> {
  List <ProPlayer> list = [];

  @override
  ProPlayersState get initialState => ProPlayersUnitializedState();

  @override
  Stream<ProPlayersState> mapEventToState(ProPlayersEvent event) async* {
    if (event is ProPlayersFetchStarted) {

      yield ProPlayersLoading();
      try {
        yield ProPlayersLoading();
        List<ProPlayer> list = await fetchProPlayers();
        this.list = list;
        yield ProPlayersFetchedState(list: list);
      } catch (error) {
        yield ProPlayersErrorState(error: error);
      }
    }

  }
}
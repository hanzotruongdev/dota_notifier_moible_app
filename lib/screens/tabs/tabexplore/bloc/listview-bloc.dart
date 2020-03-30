
import 'package:bloc/bloc.dart';
import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:flutter/cupertino.dart';

///
/// Event
/// 
abstract class ListViewEvent {}
class ListViewProPlayersUpdated extends ListViewEvent {}
class ListViewSubscriptionUpdated extends ListViewEvent {}
class ListViewSearchChanged extends ListViewEvent {
  final String text;
  ListViewSearchChanged({@required this.text});
}

class ListViewErrorOccurEvent extends ListViewEvent {
  final String error;
  ListViewErrorOccurEvent({@required this.error});
}


///
/// State
/// 
abstract class ListViewState {
  get list => null;
  String get error => null;
}

class ListViewUpdatedState extends ListViewState {
  List<ProPlayer> list = [];
  bool loading = true;

  ListViewUpdatedState({this.list, this.loading});
}

class ListViewUninitializedStage extends ListViewState {
  List<ProPlayer> list = [];
  bool loading = false;

  ListViewUninitializedStage({this.list, this.loading});
}

class ListViewErrorState extends ListViewState {
  final String error;
  ListViewErrorState({@required this.error});
}

///
/// Bloc
/// 
class ListViewBloc extends Bloc<ListViewEvent, ListViewState> {
  
  ProPlayersBloc proPlayersBloc;
  SubscribesBloc subscribesBloc;
  List<ProPlayer> fullList = [];
  List<ProPlayer> list = [];
  String searchStr = "";

  bool loading = true;

  ListViewBloc({this.proPlayersBloc, this.subscribesBloc});
  
  @override
  ListViewState get initialState {
    return ListViewUninitializedStage(list:this.list);
  }

  void _updateDisplayList() {
    if (this.fullList.length == 0){
      return;
    }

    if (this.searchStr == ""){
      this.list = this.fullList;
      return;
    }

    this.list =  this.fullList.where((player) {
      String playerName = (player.teamtag != null && player.teamtag != "") ? "${player.teamtag}.${player.name}" : "${player.name}";
      return playerName.toLowerCase().contains(this.searchStr);
    }).toList();
  }

  @override
  Stream<ListViewState> mapEventToState(ListViewEvent event) async * {

    //ListViewProPlayersFetched
    if (event is ListViewProPlayersUpdated) {

      // set loading before process this event
      yield ListViewUpdatedState(list: this.list, loading: true );
      // save list
      this.fullList = this.proPlayersBloc.list;
      var subscriptionList = (this.subscribesBloc != null) ? this.subscribesBloc.list : [];

      // map the old subscriptions to the new obtained fresh list
      if (subscriptionList.length > 0) {
        for (var i = 0; i < subscriptionList.length; i ++) {
          for (var j = 0; j < this.list.length; j ++){
            if (subscriptionList[i].accountId == this.list[j].accountid){
              this.list[j].subscribe = true;
            }
          }
        }
      }

      this._updateDisplayList();

      // return updated list and set loading to false meaning done!
      yield ListViewUpdatedState(list: this.list, loading: false);
    }
    
    // ListViewSubscriptionFetched
    else if (event is ListViewSubscriptionUpdated) {

      // set loading before process this event
      yield ListViewUpdatedState(list: this.list, loading: true );

      var subscriptionIdList = this.subscribesBloc.list;

      if (this.list != null && this.list.length >0 && subscriptionIdList.length > 0) {

        // generate a new subsciption list
        var subscriptionList = [];
        for (var i = 0; i < subscriptionIdList.length; i ++) {
          for (var j = 0; j < this.list.length; j ++){
            if (subscriptionIdList[i].accountId == this.list[j].accountid){
              this.list[j].subscribe = true;
              subscriptionList.add(this.list[j]);
              break;
            }
          }
        }

        // update the list
        for (var i = 0; i < this.list.length; i ++) {
          var subscribe = false;
          for (var j = 0; j < subscriptionIdList.length; j ++){
            if (this.list[i].accountid == subscriptionIdList[j].accountId){
              subscribe = true;
              break;
            }
          }
          this.list[i].subscribe = subscribe;
        }
      }

      this._updateDisplayList();

      // return updated list and set loading to false meaning done!
      yield ListViewUpdatedState(list: this.list, loading: false );
    }

    else if (event is ListViewSearchChanged) {
      this.searchStr = event.text.toLowerCase();
      this._updateDisplayList();
      yield ListViewUpdatedState(list:  this.list, loading: false);
    }

    // error ListViewErrorOccurEvent
    else if (event is ListViewErrorOccurEvent) {
      yield ListViewErrorState(error: event.error);
    }


  }

}
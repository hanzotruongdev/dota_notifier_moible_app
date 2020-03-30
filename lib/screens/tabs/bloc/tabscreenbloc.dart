

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

///
/// HomeEvent
/// 
abstract class TabScreenEvent {}

class BottomNavigationTabTapped extends TabScreenEvent {
  final int index;
  BottomNavigationTabTapped({@required this.index});
}

///
/// HomeState
/// 
abstract class TabScreenState {
  get index => this.index;
}

class TabScreenUninitializedState extends TabScreenState {
  final int index = 0;
}
class TabScreenInitializedState extends TabScreenState {
  final int index;
  TabScreenInitializedState({@required this.index});
}

///
/// HomeBloc
/// 
class TabScreenBloc extends Bloc<TabScreenEvent, TabScreenState> {
  @override
  get initialState => TabScreenUninitializedState();

  @override
  Stream<TabScreenState> mapEventToState(TabScreenEvent event) async* {
    if (event is BottomNavigationTabTapped){
      yield TabScreenInitializedState(index: event.index);
    }
  }
}
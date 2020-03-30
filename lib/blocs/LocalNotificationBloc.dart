
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///
/// event
/// 
abstract class LnEvent {}
class LnAppStarted extends LnEvent {}
class LnMessageReceived extends LnEvent {
  final String title;
  final String body;
  LnMessageReceived({@required this.title, @required this.body});
}

///
/// stage
/// 
abstract class LnState {}

class LnUninitializedState extends LnState {}
class LnInitializedState extends LnState {}

//
//  bloc
//
class LocalNotificationBloc extends Bloc <LnEvent, LnState> {

  // instance of Flutter_local_notification 
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  

  @override
  LnState get initialState => LnUninitializedState();

  @override
  Stream<LnState> mapEventToState(LnEvent event) async* {
    if (event is LnAppStarted) {
      // init Flutter_Local_Notification
      var initializationSettingsAndroid = new AndroidInitializationSettings('ic_notification'); 
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
      yield LnInitializedState();
    }
    if (event is LnMessageReceived) {
      // process show message
      pushLocalNotification(event.title, event.body);
      yield LnInitializedState();
    }

    else {
      yield LnInitializedState();
    }

  }
  

  void pushLocalNotification(String title, String body){

    /// init some seting before push
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    // push notification to system!!!
    this.flutterLocalNotificationsPlugin.show(
      0, 
      title,
      body,
      platformChannelSpecifics,
      payload: "Test payload"
    );
  }

  Future onSelectNotification (String payload) async { }

}
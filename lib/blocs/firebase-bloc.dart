import 'package:bloc/bloc.dart';
import 'package:dota_notifier/blocs/LocalNotificationBloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Event
/// 
abstract class FirebaseEvent {}
class FirebaseAppStarted extends FirebaseEvent {}
class FirebaseLogedout extends FirebaseEvent {}

///
/// AuthStage
/// 
abstract class FirebaseState  {
}

class FirebasehUninitializedState extends FirebaseState {}

class FirebaseInitializedState extends FirebaseState {}


///
/// AuthBloc
/// 
class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  LocalNotificationBloc localNotificationBloc;

  BuildContext context;
  String token;

  FirebaseBloc();

  @override
  FirebaseState get initialState => FirebasehUninitializedState();

  @override
  Stream<FirebaseState> mapEventToState(FirebaseEvent event) async * {

    if (event is FirebaseAppStarted) {
      this.config();
    }

    if (event is FirebaseLogedout) {
      var res = firebaseMessaging.deleteInstanceID();
      this.token = "";
      print("FirebaseBloc: Deleted Instatnce ID, $res");

      // generate new token
      newToken();
    }

    yield FirebaseInitializedState();
  }

  ///
  /// custom function for config firebase
  /// 
  void config() {
    
    print("-- Config firebase! --");

    // config callback
    this.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("FirebaseBloc onMessage: $message");
        
        var notificaiton = message['notification'];
        var title = notificaiton['title'];
        var body = notificaiton['body'];

        localNotificationBloc.add(LnMessageReceived(title: title, body: body));
      },
      onLaunch: (Map<String, dynamic> message) async { },
      onResume: (Map<String, dynamic> message) async { },
    );


    // request permissions
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
      firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});

    // set not auto init
    firebaseMessaging.setAutoInitEnabled(false);

    // get token
    newToken();
  }

  void newToken() {
    // get token
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      this.token = token;
      print("FirebaseBloc Messaging Token: $token");
    });
  }
  
}



  

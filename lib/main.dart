import 'package:dota_notifier/blocs/LocalNotificationBloc.dart';
import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:dota_notifier/blocs/profile-bloc.dart';
import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:dota_notifier/screens/tabs/tabscreen.dart';
import 'package:dota_notifier/screens/login/loginscreen.dart';
import 'package:dota_notifier/screens/splash/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:dota_notifier/routes.dart';
import 'package:dota_notifier/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'blocs/blocs.dart';
import 'components/loading_indicator.dart';

void main() {
  final userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<AuthBloc>(create:(_) => AuthBloc(userRepository: userRepository)..add(AppStarted())),
        BlocProvider<ProPlayersBloc>(create: (_) => ProPlayersBloc()..add(ProPlayersFetchStarted())),
        BlocProvider<SubscribesBloc>(create: (_) => SubscribesBloc(),),
        BlocProvider<FirebaseBloc>(create: (_) => FirebaseBloc()..add(FirebaseAppStarted())),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<LocalNotificationBloc>(create: (_) => LocalNotificationBloc()..add(LnAppStarted()))
      ],
      child: DotaNotifierApp(userRepository: userRepository)
    )
  );
}

class DotaNotifierApp extends StatelessWidget {
  final UserRepository userRepository;

  DotaNotifierApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Dota Notifier',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: Color(0xff008ff4)
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android : CupertinoPageTransitionsBuilder()
            }
          )
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context1, state) {
            if (state is AuthAuthenticated) {
              
              BlocProvider.of<FirebaseBloc>(context).localNotificationBloc = BlocProvider.of<LocalNotificationBloc>(context);
              
              BlocProvider.of<SubscribesBloc>(context).authBloc = BlocProvider.of<AuthBloc>(context);
              BlocProvider.of<SubscribesBloc>(context).firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
              BlocProvider.of<SubscribesBloc>(context).add(SubscribesFetchStarted());

              BlocProvider.of<ProfileBloc>(context).authBloc = BlocProvider.of<AuthBloc>(context);
              BlocProvider.of<ProfileBloc>(context).firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
              BlocProvider.of<ProfileBloc>(context).add(ProfileFetchStarted());
              
              return TabScreen();
            }
            if (state is AuthUnauthenticated) {
              return LoginScreen();
            }
            if (state is AuthLoading) {
              return LoadingIndicator();
            }
            return SplashScreen();
          },
        ),
        routes: routes,
      )
    );
  }
}

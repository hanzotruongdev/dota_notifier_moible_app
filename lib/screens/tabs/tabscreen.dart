
import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:dota_notifier/screens/tabs/bloc/tabscreenbloc.dart';
import 'package:dota_notifier/screens/tabs/tabexplore/bloc/listview-bloc.dart';
import 'package:dota_notifier/screens/tabs/tabexplore/tabexplore.dart';
import 'package:dota_notifier/screens/tabs/tabprofile/tabprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabScreen extends StatelessWidget {
  final List<Widget> _children = [
    // TabHome(),
    BlocProvider(
      create: (context) {
        // create and assign to other blocs
        ListViewBloc bloc = ListViewBloc();
        bloc.proPlayersBloc = BlocProvider.of<ProPlayersBloc>(context);
        bloc.subscribesBloc = BlocProvider.of<SubscribesBloc>(context);
        bloc.add(ListViewProPlayersUpdated());
        bloc.add(ListViewSubscriptionUpdated());
        return bloc;
      },
      child: TabExplore()
    ), TabProfile()
  ];

  

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => TabScreenBloc(),
      child: BlocBuilder <TabScreenBloc, TabScreenState>(
        builder: (context, state) {

          void onTabTapped(i) {
            BlocProvider.of<TabScreenBloc>(context).add(BottomNavigationTabTapped(index: i));
          }

          return Scaffold(
            body: _children[state.index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.index, 
              onTap: onTabTapped,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: [
                /// the Home screen is now under developing!
                /// We are temporarily disabling it

                // BottomNavigationBarItem(
                //   icon: new Icon(Icons.dashboard, size: 32),
                //   title: Text("Dashboard"),
                // ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.find_in_page, size: 32),
                  title: Text("Explore")
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 32),
                  title: Text("Profile")
                )
              ],
            ),
          );
        }));
  }
}

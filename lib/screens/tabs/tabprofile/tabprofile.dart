import 'package:dota_notifier/blocs/auth-bloc.dart';
import 'package:dota_notifier/blocs/firebase-bloc.dart';
import 'package:dota_notifier/blocs/profile-bloc.dart';
import 'package:dota_notifier/components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
          
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10,),
            CInputField(
              icon: Icons.email, 
              centerWidget: Text((state is ProfileFetchedState) ? state.profile.email : '',),
            ),
            CInputField(
              icon: Icons.notifications, 
              centerWidget: Text("Notifiy me all new matches"),
              switchButton: Switch(
                  onChanged: (value) {
                    BlocProvider.of<ProfileBloc>(context).add(ProfileChangeSubmited(subscribeAll: value));
                  },
                  value: (state is ProfileFetchedState) ? state.profile.subscribeAll : false,
              )
            ),
          ],      
        );
      }
    );
  
  }
}

class TabProfile extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileFetchedState || state is ProfileLoadingState) {

          return Scaffold(
            body: SingleChildScrollView(
              child: Column( children: <Widget>[
                Container(
                  height: 100,
                  alignment: Alignment.bottomRight,
                    child: FlatButton(
                      child: Icon(Icons.settings),
                      onPressed: () {},
                  ),
                ),

                Container(
                    height: 160,
                    child: Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage( "assets/images/default-avatar.png")
                      ),
                    ),
                ),
                ProfileInfo(),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: MButton(
                    text: "Logout", callback: () {
                      BlocProvider.of<FirebaseBloc>(context).add(FirebaseLogedout());
                      BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                    }
                  ),
                )
              ],)
            )
          );
          
        } 

        else if (state is ProfileErrorState) {
          return Center(
          
            child: Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Center(child: Text(state.error)),
              MButton(
                text: "Logout", callback: () {
                  BlocProvider.of<FirebaseBloc>(context).add(FirebaseLogedout());
                  BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                }
              ),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
            )
          );
        }

        else {
          return Center(child: Text("Unknow Error!"),);
        }
      },
    );
    
  }
}


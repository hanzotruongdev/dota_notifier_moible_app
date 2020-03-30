
import 'dart:async';

import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:dota_notifier/screens/tabs/tabexplore/Playercard.dart';
import 'package:dota_notifier/screens/tabs/tabexplore/bloc/listview-bloc.dart';
import 'package:dota_notifier/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Timer delaySent;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Container(
          height: 120,
          width: width,
          decoration: BoxDecoration(
            color: appTheme().primaryColor,
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomRight,
            children: <Widget>[
              // Positioned(
              //     top: 30,
              //     right: -100,
              //     child: _circularContainer(300, Color(0xFF292929))),
              // Positioned(
              //     top: -100,
              //     left: -45,
              //     child: _circularContainer(width * .5, LightColor.darkpurple)),
              Positioned(
                  top: 30,
                  right: -100,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Color(0xFF292929))),
              Positioned(
                  top: -100,
                  left: -45,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Color(0xff202020))),
              Positioned(
                  top: -180,
                  right: -30,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Color(0xff202020))),
              Positioned(
                  top: 60,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                ),
                              ),
                              Container(
                                width: 120 ,
                                height: 26,
                                child: TextField(
                                  onChanged: (value) async {

                                    if (delaySent != null)
                                      delaySent.cancel();

                                    delaySent = Timer(Duration(milliseconds: 300), (){
                                      BlocProvider.of<ListViewBloc>(context).add(ListViewSearchChanged(text: value));
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xff1e57c9),
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                                    hintText: "",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0), 
                                      borderSide: const BorderSide(color: Color(0xff1e57c9), width: 0.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0), 
                                      borderSide: const BorderSide(color: Color(0xff1e57c9), width: 0.0),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0), 
                                      borderSide: const BorderSide(color: Color(0xff1e57c9), width: 0.0),
                                    ),
                                    
                                    suffixIcon: Icon(Icons.search, color: Colors.black,),
                                  ),
                                
                              ),
                              )
                            ],
                          ),
                        ],
                      )))
            ],
          )),
    );
  }

class TabExplore extends StatelessWidget {
  // backing data
  
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProPlayersBloc, ProPlayersState>(
          listener: (context1, state) {
            if (state is ProPlayersFetchedState){
              BlocProvider.of<ListViewBloc>(context).add(ListViewProPlayersUpdated());
            }
          },
        ),
        BlocListener<SubscribesBloc, SubscribesState>(
          listener: (context2, state) {
            if (state is SubscribesFetchedState){
              BlocProvider.of<ListViewBloc>(context).add(ListViewSubscriptionUpdated());
            }
          },
        )
      ],
      child: BlocBuilder<ListViewBloc, ListViewState>(
        builder: (context, state) {
          if (state is ListViewUpdatedState || state is ListViewUninitializedStage) {
            
            return Scaffold(
              // appBar: AppBar(title: TextField(decoration: new InputDecoration(
              //     suffixIcon: new Icon(Icons.search, color: Colors.white,),
              //     hintText: 'Search...'
              //   ),),),
              body: RefreshIndicator(
                onRefresh:  () async {
                  BlocProvider.of<ProPlayersBloc>(context).add(ProPlayersFetchStarted());
                  BlocProvider.of<SubscribesBloc>(context).add(SubscribesFetchStarted());
                  return;
                },
                child: Container(
                    child: Column(
                      children: <Widget>[
                        _header(context),
                        SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: Text("#PLAYERS", style: TextStyle(
                            color: Color(0xff2e74ff),
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                          )),
                        ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: ListView.builder(
                          itemCount: state.list.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return PlayerCard(player: state.list[index]);
                          },
                        ),
                        )
                      ],
                    )
                  )
                
              ) 
            );
            
          } 

          if (state is ListViewErrorState) {
            return Column(children: <Widget>[
              Center(child: Text(state.error))
            ]);
          }

          return Center(child: CircularProgressIndicator());
          
        },
      )
    );
    
  }
}
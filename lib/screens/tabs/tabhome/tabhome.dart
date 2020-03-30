import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
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
                                "Home",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                ),
                              ),
                              
                            ],
                          ),
                        ],
                      )))
            ],
          )),
    );
  }

class TabHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
      listeners: [
        BlocListener<ProPlayersBloc, ProPlayersState>(
          listener: (context1, state) {
            if (state is ProPlayersFetchedState){
            }
          },
        ),
        BlocListener<SubscribesBloc, SubscribesState>(
          listener: (context2, state) {
            if (state is SubscribesFetchedState){
            }
          },
        )
      ],
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
            
          ],
        )
      ),
      );
    }
  }
    
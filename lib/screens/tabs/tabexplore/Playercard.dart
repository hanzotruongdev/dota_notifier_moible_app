
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerCard extends Card {
  final ProPlayer player;

  PlayerCard({@required this.player});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        BlocProvider.of<SubscribesBloc>(context).add(
          player.subscribe ? SubscribesUnsubToPlayerStarted(playerId: player.accountid) 
          : SubscribesSubToPlayerStarted(playerId: player.accountid));
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Color(0xFF171717),
          borderRadius: BorderRadius.circular(15)
        ),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: player.avatarfull, width: 60, 
              ),
            ),
            
            SizedBox(width: 17,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 224,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: (player.teamtag != null && player.teamtag != "") ? "${player.teamtag}." : "", style: TextStyle(color: Colors.black87, fontSize: 18)),
                        TextSpan(text: player.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                      ]
                    )
                  ),
                ),
                SizedBox(height: 2,),
                Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(width: 20, height: 20, child: Icon(Icons.flag, color: Color(0xFF707070))),
                    imageUrl: 'https://steamcommunity-a.akamaihd.net/public/images/countryflags/${player.countrycode}.gif',width: 20,
                  ),
                ),
                SizedBox(height: 2,),
                SizedBox(
                  width: 224,
                    child: Text("Team: ${player.teamname}", overflow: TextOverflow.fade, style: TextStyle(
                    color: Color(0xFF707070),
                    fontSize: 12
                  ),),
                )
              ],
            ),
            Spacer(),
            Container(
              child: Icon(Icons.notifications, color: player.subscribe ? Colors.blue : Colors.black12,),
            )
          ],
        ),
      ),
    ); 
  }
}
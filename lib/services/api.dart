import 'dart:async';
import 'dart:convert';
import 'package:dota_notifier/blocs/profile-bloc.dart';
import 'package:dota_notifier/blocs/proplayers-bloc.dart';
import 'package:dota_notifier/blocs/subscribes-bloc.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/user_repository.dart';


Future<Map> login(String email, String password, {String firebaseToken}) async {

  var header = Map<String, String>();

  header['email'] = email;
  header['password'] = password;
  // firebase token to server to resubscribe topic
  if (firebaseToken != null && firebaseToken != ''){
    header['firebase_token'] = firebaseToken;
  }

  http.Response response = await http.post("https://dotanotifier.herokuapp.com/api/auth/login",
    headers: header
  );
  var jres  = jsonDecode(response.body);

  var token = jres['access_token'] ?? '';
  var refreshToken = jres['refresh_token'] ?? '';
  
  if (token == '')
    throw jres['msg'];
  
  return {'token': token, 'refreshToken': refreshToken};
}

Future<String> refresh(String refreshToken) async {
  var header = Map<String, String>();
  header['Authorization'] = refreshToken;

  http.Response res = await http.post("https://dotanotifier.herokuapp.com//api/auth/refresh",
    headers: header
  );

  String token = "";
  var jres = jsonDecode(res.body);

  if (res.statusCode == 200) {
    token = jres['access_token'] ?? '';
  }

  if (token == '')
    throw jres['msg'];

  return token;
}

Future<bool> signup(String email, String password) async {
  var header = Map<String, String>();
  header['email'] = email;
  header['password'] = password;

  http.Response response = await http.post("https://dotanotifier.herokuapp.com/api/auth/signup",
    headers: header
  );
  var jres  = jsonDecode(response.body);

  if (response.statusCode == 200)
    return true;

  else
    throw jres['msg'];
}

Future<dynamic> callApi(UserRepository userRepository, String endpoint, String method, [Map<String, String> headers, Map<String, dynamic> body]) async {
  Map<String, dynamic> methods = {'POST': http.post, 'GET': http.get, 'PUT': http.put, 'PATCH': http.patch, 'DELETE': http.delete};
  
  http.Response res = (body != null) ? await methods[method](endpoint, headers: headers, body: body) : await methods[method](endpoint, headers: headers);

  // if session experied, we get the new refresh token
  if(res.statusCode == 401) {
    
    var newToken = await userRepository.reAuthenticate();
    headers['Authorization'] = newToken;
    res = (body != null) ? await methods[method](endpoint, headers: headers, body: body) : await methods[method](endpoint, headers: headers);

  } 

  return res;

}

// call OpenDota Api
Future<List<ProPlayer>> fetchProPlayers() async {

  http.Response res = await http.get("https://api.opendota.com/api/proPlayers");

  if (res.statusCode == 200) {
    var jres = jsonDecode(res.body);

    List<ProPlayer> list = [];

    for (var i = 0; i < jres.length; i++){
      var p = jres[i];
      ProPlayer player = ProPlayer( accountid: "${p['account_id']}",  steamid: p['steammid'],  avatarfull: p['avatarfull'],  profileurl: p['profileurl'],  name: p['name'],  countrycode: p['country_code'],  teamid: "${p['team_id']}",  teamname: p['team_name'],  teamtag: p['team_tag']);
      list.add(player);
    }
    
    return list;
  } else {
    throw "Error while fetching the Pro player list!";
  }
}

Future<List<Channel>> fetchSubscribes(UserRepository userRepository) async {


  Map<String, String> header = Map();
  header['Authorization'] = userRepository.token;

  var res = await callApi(
    userRepository, 
    "https://dotanotifier.herokuapp.com/api/subscribes", 
    'GET',
    header
  );

  if (res.statusCode == 200) {
    var jres = jsonDecode(res.body);

    List<Channel> list = [];
    
    for (var i = 0; i < jres.length; i++){
      Channel c = Channel(accountId: jres[i]);
      list.add(c);
    }
    return list;
  } else {
    throw "Error while fetching the Pro player list!";
  }
}

///
/// Function call api to subscribe to a Pro Players
/// 
Future<void> subscribeToPlayer(UserRepository userRepository, String firebaseToken, String playerId) async {

  var header = Map<String, String>();
  header['Authorization'] = userRepository.token;
  header['playerid'] = playerId;
  header['firebasetoken'] = firebaseToken;

  var res = await callApi(
    userRepository, 
    "https://dotanotifier.herokuapp.com/api/subscribes", 
    'POST',
    header
  );

  // parse result
  if (res.statusCode == 200) {
    return true;
  } else {
    throw "Error while calling api subscribe!";
  }
} 

///
/// Function call api to Unsubscribe to a Pro Players
/// 
Future<bool> unsubscribeToPlayer(UserRepository userRepository, String firebaseToken, String playerId) async {

  var header = Map<String, String>();
  header['Authorization'] = userRepository.token;
  header['playerid'] = playerId;
  header['firebasetoken'] = firebaseToken;

  var res = await callApi(
    userRepository, 
    "https://dotanotifier.herokuapp.com/api/subscribes", 
    'DELETE',
    header
  );

  // parse result
  if (res.statusCode == 200) {
    return true;
  } else {
    throw "Error while calling api subscribe!";
  }
} 


Future<Profile> fetchProfile(UserRepository userRepository) async {

  var header = Map<String, String>();
  header['Authorization'] = userRepository.token;

  var res = await callApi(
    userRepository, 
    "https://dotanotifier.herokuapp.com/api/users/profile", 
    'GET',
    header
  );

  var jres = jsonDecode(res.body);

  // parse result
  if (res.statusCode == 200) {

    Profile p = Profile();
    p.id = jres['id'];
    p.email = jres['email'];
    p.name = jres['name'];
    p.subscribeAll = (jres['subscribeAll'] == 1 ? true : false);
    
    return p;

  } else {

    throw jres['msg'];

  }
}


Future<void> updateProfile(UserRepository userRepository, String firebaseToken, bool subscribeAll) async {

  var header = Map<String, String>();
  header['Authorization'] = userRepository.token;
  header['subscribeAll'] = subscribeAll ? '1' : '0';
  header['firebaseToken'] = firebaseToken;

  var res = await callApi(
    userRepository, 
    "https://dotanotifier.herokuapp.com/api/users/profile", 
    'PATCH',
    header
  );

  // parse result
  if (res.statusCode == 200) {
    var jres = jsonDecode(res.body);
    print(jres);

    return;
  } else {
    throw "Error while calling api updateProfile!";
  }
}

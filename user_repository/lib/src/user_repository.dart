import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dota_notifier/services/api.dart';

class UserRepository {
  String token = "";
  String refershToken = "";
  String preUser = "";

  Future<String> authenticate({
    @required String email,
    @required String password,
    String firebaseToken
  }) async {
    var res = await login(email, password, firebaseToken: firebaseToken);
    refershToken = res['refreshToken'];
    token = res['token'];

    persistToken(token);

    return token;
  }

  Future<String> reAuthenticate() async {
    var t = await refresh(refershToken);
    token = t;

    return token;
  }

  Future<bool> register({
      @required String email,
      @required String password,
    }
  ) async {
    return await signup(email, password);
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    await prefs.setString('refreshToken', '');
    this.token = "";
    this.refershToken = "";

    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('refreshToken', refershToken);
    this.token = token;
    return;
  }

  Future<void> savePreviousUser(String email) async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    await perfs.setString('pre-user', email);
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.token = prefs.getString('token') ?? '';
    this.refershToken = prefs.getString('refreshToken') ?? '';
    this.preUser = prefs.getString('pre-user') ?? '';
    print("saved token in Pref: $token");
    print("Saved refresh token in Pref: $refershToken");

    return token != '';
  }
}

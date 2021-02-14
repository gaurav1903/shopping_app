import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userid;
  Timer _authtimer;

  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDa585-C2kbUd9nC1RDUg297Ys9nus9UO4";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) //if exists
      {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userid = responsedata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autologout();
      notifyListeners();
      setUserPreferences();
    } catch (e) {
      throw e;
    }
  }

  Future<void> setUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userdata = json.encode({
      'token': _token,
      'expirydate': _expirydate.toIso8601String(),
      'userid': _userid
    });
    prefs.setString('userdata', userdata);
  }

  Future<bool> tryautologin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userdata')) return false;
    final extracted = pref.getString('userdata');
    print('extracted dat auto login');
    print(extracted);
    final extracteddata = json.decode(extracted) as Map<String, Object>;
    final expiry = DateTime.parse(extracteddata['expirydate']);
    if (expiry.isBefore(DateTime.now())) return false;
    _token = extracteddata['token'];
    _expirydate = expiry;
    _userid = extracteddata['userid'];
    notifyListeners();
    autologout();
    return true;
  }

  void autologout() {
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    final secs = _expirydate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: secs), logout);
  }

  Future<void> logout() async {
    _token = null;
    _userid = null;
    _expirydate = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.remove('userdata');
    // pref.clear();
  }

  Future<void> login(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDa585-C2kbUd9nC1RDUg297Ys9nus9UO4";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) //if exists
      {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userid = responsedata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      print("token $_token");
      autologout();
      notifyListeners();
      setUserPreferences();
    } catch (e) {
      throw e;
    }
  }

  String get userid {
    return _userid;
  }

  bool get isAuth {
    print(token != null);
    return token != null; //false if not authenticated
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else
      return null;
  }
}

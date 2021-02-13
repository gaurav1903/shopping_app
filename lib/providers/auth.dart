import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userid;
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
      _token = responsedata['idtoken'];
      _userid = responsedata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      notifyListeners();
    } catch (e) {
      throw e;
    }
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
      notifyListeners();
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

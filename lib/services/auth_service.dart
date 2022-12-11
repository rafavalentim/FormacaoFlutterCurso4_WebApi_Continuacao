import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_second_course/services/webclient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  String url = WebClient.url;
  http.Client client = WebClient().client;

  Future<bool>login({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      body: {
        'email' : email,
        'password' : password,
      }
    );

    if(response.statusCode != 200){
      String content = json.decode(response.body);

      switch(content){
        case "Cannot find user" : throw UserNotFindException();
        case "jwt expired" : throw TokenExpiredException();
      }

      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  Future<bool>register({required String email, required String password}) async {

    http.Response response = await client.post(
        Uri.parse('${url}register'),
        body: {
          'email' : email,
          'password' : password,
        }
    );

    if(response.statusCode != 201){
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body) async{
    Map<String, dynamic> map = json.decode(body);

    //Acessando o token
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    //print("$token\n$email\n$id");

    // Instanciando um SharedPreferences para armazenar os dados do usuário.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);
  }
}

class UserNotFindException implements Exception{}
class TokenExpiredException implements Exception{}

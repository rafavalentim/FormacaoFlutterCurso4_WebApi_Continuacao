import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'http_interceptors.dart';

class AuthService {
  //TODO: Modularizar o endpoint
  static const String url = "http://192.168.0.15:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

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
      }

      throw HttpException(response.body);
    }
    return true;
  }

  register({required String email, required String password}) async {

    http.Response response = await client.post(
        Uri.parse('${url}register'),
        body: {
          'email' : email,
          'password' : password,
        }
    );

    if(response.statusCode != 200){
      throw HttpException(response.body);
    }else{

    }

  }
}

class UserNotFindException implements Exception{}

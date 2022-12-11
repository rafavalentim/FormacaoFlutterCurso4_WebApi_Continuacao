import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_second_course/services/webclient.dart';
import 'package:http/http.dart' as http;

import '../models/journal.dart';

//Comando para rodar o json server com as todas definidas no routes.json.
//json-server-auth --watch -host SEU_IP_AQUI db.json -r routes.json

class JournalService {

  static const String resource = "journals/";
  String url = WebClient.url;
  http.Client client = WebClient().client;

  String getURL() {
    return "$url$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<bool> register(Journal journal, String token) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.post(
      getUri(),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: journalJSON,
    );

    if (response.statusCode != 201) {
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    //Atualizando a data de update
    journal.updatedAt = DateTime.now();

    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getURL()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: journalJSON,
    );

    if (response.statusCode != 200) {
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});

    List<Journal> result = [];

    if (response.statusCode != 200) {
      //TODO: Criar uma exceção personalizada
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw HttpException(response.body);

    }

    List<dynamic> jsonList = json.decode(response.body);
    for (var jsonMap in jsonList) {
      result.add(Journal.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
        Uri.parse("${getURL()}$id"),
        headers: {"Authorization": "Bearer $token"},
        );

        if (response.statusCode != 200) {
          if(json.decode(response.body) == "jwt expired"){
            throw TokenNotValidException();
          }
          throw HttpException(response.body);
        }
        return true;
        }
    }

    //Classes de exceção
class TokenNotValidException implements Exception{


}

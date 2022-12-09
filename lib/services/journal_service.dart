import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';
import 'http_interceptors.dart';

//Comando para rodar o json server com as todas definidas no routes.json.
//json-server-auth --watch -host SEU_IP_AQUI db.json -r routes.json

class JournalService {
  static const String url = "http://192.168.0.15:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

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

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getURL()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: journalJSON,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});

    List<Journal> result = [];

    if (response.statusCode != 200) {
      //TODO: Criar uma exceção personalizada
      //throw Exception();
      return result;
    }

    List<dynamic> jsonList = json.decode(response.body);
    for (var jsonMap in jsonList) {
      result.add(Journal.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> delete(String id) async {
    http.Response response = await http.delete(Uri.parse("${getURL()}$id"));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

import 'package:http/http.dart' as http;
import 'package:liberacion/exceptions.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const api_url = 'http://134.122.57.83:8081';

String api(route) {
  return api_url + route;
}

respond(response) {
  if (response.statusCode == 401 || response.statusCode == 400) throw UnauthorizedException();
  if (response.statusCode == 403) throw ForbiddenException();
  if (response.statusCode == 422) throw UnprocessableEntityException();
  return jsonDecode(response.body);
}

Future<Map<String, String>> headers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

getFromApi(route) {
  return headers().then((headers) => http.get(api(route), headers: headers)).then((response) => respond(response));
}

postToApi(route, params) {
  return headers().then((headers) => http.post(api(route), headers: headers, body: jsonEncode(params))).then((response) => respond(response));
}
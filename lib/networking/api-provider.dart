import 'package:cash_droid/networking/custom-exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  Future<dynamic> get(String url, {required String header}) async {
    var responseJson;

    try {
      final response = await http.get(
        Uri.parse(url), // Convert the String URL to Uri object.
        headers: {HttpHeaders.authorizationHeader: 'Bearer $header'},
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String body, String header) async {
    var responseJson;

    try {
      final response = await http.post(
        Uri.parse(url), // Convert the String URL to Uri object.
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $header',
        },
        body: body,
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, String body, String header) async {
    var responseJson;

    try {
      final response = await http.put(
        Uri.parse(url), // Convert the String URL to Uri object.
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $header',
        },
        body: body,
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String url, String body, String header) async {
    var responseJson;

    try {
      final response = await http.patch(
        Uri.parse(url), // Convert the String URL to Uri object.
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $header',
        },
        body: body,
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, String header) async {
    var responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url), // Convert the String URL to Uri object.
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $header',
        },
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;

      case 204:
        return true;
      case 400:
        throw BadRequestException(response.body);
      case 401:

      case 403:
        throw UnauthorisedException(response.body);

      case 404:
        return null;

      case 406:
        throw BadRequestException(response.body);
      case 500:

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

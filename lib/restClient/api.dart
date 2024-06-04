import 'dart:convert';
import 'package:forky_app_provider/core/env.dart';
import 'package:http/http.dart' as http;

class Api {
  
  static final Api _singleton = Api._internal();
  String _baseUrl = Env.backendBaseUrl;

  factory Api() {
    return _singleton;
  }

  Api._internal();

  void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  String? get baseUrl => _baseUrl;

  Future doGet({
    String endpoint = '',
    String params = '',
    int timeout = 60,
  }) async {
    var url = '$_baseUrl$endpoint';
    if (params.isNotEmpty) {
      url += '?$params';
    }
    try {

      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: timeout));
      if ([200, 201].contains(response.statusCode)) {
        final body = json.decode(response.body);
        return body;
      } else {
        throw response.body;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future doPost({
    String endpoint = '',
    String params = '',
    dynamic body,
    int timeout = 60,
  }) async {
    var url = '$_baseUrl$endpoint';
    if (params.isNotEmpty) {
      url += '?$params';
    }
    try {

      final response = await http
          .post(
            Uri.parse(url),
            body: body,
          )
          .timeout(Duration(seconds: timeout));
      if ([200, 201].contains(response.statusCode)) {
        final body = json.decode(response.body);
        return body;
      } else {
        throw response.body;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future doPut({
    String? endpoint,
    dynamic body,
    int timeout = 60,
  }) async {
    var url = '$_baseUrl$endpoint';

    try {

      final response = await http
          .put(
            Uri.parse(url),
            body: body,
          )
          .timeout(Duration(seconds: timeout));
      if ([200, 201].contains(response.statusCode)) {
        final body = json.decode(response.body);
        return body;
      } else {
        throw response.body;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future doPath({
    String? endpoint,
    dynamic body,
    int timeout = 60,
  }) async {
    var url = '$_baseUrl$endpoint';

    try {

      final response = await http
          .patch(
            Uri.parse(url),
            body: body,
          )
          .timeout(Duration(seconds: timeout));
      if ([200, 201].contains(response.statusCode)) {
        final body = json.decode(response.body);
        return body;
      } else {
        throw response.body;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future doDelete({
    String? endpoint,
    dynamic body,
    int timeout = 60,
  }) async {
    var url = '$_baseUrl$endpoint';

    try {

      final response = await http
          .delete(
            Uri.parse(url),
            body: body,
          )
          .timeout(Duration(seconds: timeout));
      if ([200, 201].contains(response.statusCode)) {
        final body = json.decode(response.body);
        return body;
      } else {
        throw response.body;
      }
    } catch (exception) {
      rethrow;
    }
  }
}

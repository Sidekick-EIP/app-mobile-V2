import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  final String apiKey;

  ApiClient(this.baseUrl, this.apiKey);

  Uri buildUrl(String endpoint, Map<String, String>? queryParams) {
    var apiUri = Uri.parse(baseUrl);
    final apiPath = "${apiUri.path}$endpoint";

    final uri = Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      path: apiPath,
      queryParameters: queryParams,
    );
    return uri;
  }

  Map<String, String> buildHeader(String? token) {
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json";
    if (token != null) headers["authorization"] = "Bearer $token";
    return headers;
  }

  ApiResponse handleResponse(http.Response response) {
    Map<String, dynamic> body = {};
    if (response.body.isNotEmpty) {
      body = json.decode(response.body);
    }
    final apiResponse = ApiResponse(response.statusCode, body);
    if (apiResponse.isSuccess()) {
      return apiResponse;
    } else {
      ApiException error = ApiException.fromJson(apiResponse.body);
      throw error;
    }
  }

  Future<ApiResponse> get({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? token,
  }) async {
    final Uri url = buildUrl(endpoint, queryParams);
    Map<String, String> requestHeaders = buildHeader(token);
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    try {
      final response = await http.get(url, headers: requestHeaders);

      ApiResponse apiResponse = handleResponse(response);

      return apiResponse;
    } on TimeoutException catch (ex) {
      debugPrint(
        'Unexepected exception obtained with request GET $endpoint\nException: $ex',
      );
      rethrow;
    } on SocketException catch (_) {
      throw ('No Internet Connection');
    } catch (ex) {
      debugPrint(
        'Unexepected exception obtained with request GET $endpoint\nException: $ex',
      );
      rethrow;
    }
  }
}

class ApiResponse {
  int statusCode;
  Map<String, dynamic> body;

  ApiResponse(this.statusCode, this.body);

  bool isSuccess() {
    return statusCode >= 200 && statusCode < 300;
  }
}

class ApiException {
  late int statusCode;
  late String message;

  ApiException(this.statusCode, this.message);

  ApiException.fromJson(Map<String, dynamic> json) {
    statusCode = json["code"];
    message = json["message"];
  }
}

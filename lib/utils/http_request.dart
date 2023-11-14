import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sidekick_app/utils/token_storage.dart';

import '../controller/user_controller.dart';

class HttpRequest {
  static Future mainGet(String url) async {
    final userController = Get.put(UserController(), permanent: true);
    final TokenStorage tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken() ?? "";
    var refreshToken = await tokenStorage.getAccessToken() ?? "";

    if (accessToken != "") {
      final response =
          await simpleGet(url, {'Authorization': 'Bearer $accessToken'});
      if (response.statusCode == 401) {
        final response = await refreshTokens(
            userController.user.value.email.value, refreshToken);
        if (response.statusCode == 201) {
          Map<String, dynamic> decodedResponse = jsonDecode(response.body);
          await tokenStorage.storeAccessToken(decodedResponse['access_token']);
          await tokenStorage
              .storeRefreshToken(decodedResponse['refresh_token']);
          return (await simpleGet(
              url, {'Authorization': 'Bearer $accessToken'}));
        }
      }
      return (response);
    } else {
      return await simpleGet(url, {'': ''});
    }
  }

  static Future mainPost(String url, body,
      {Map<String, String>? headers}) async {
    final userController = Get.put(UserController(), permanent: true);
    final TokenStorage tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken() ?? "";
    var refreshToken = await tokenStorage.getRefreshToken() ?? "";

    Map<String, String> mutableHeaders =
        headers != null ? Map<String, String>.from(headers) : {};
    if (headers == null) {
      mutableHeaders['Content-Type'] = 'application/json';
    }

    if (accessToken.isNotEmpty) {
      mutableHeaders["Authorization"] = 'Bearer $accessToken';
      final response = await simplePost(url, mutableHeaders, body);

      if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshResponse = await refreshTokens(
            userController.user.value.email.value, refreshToken);

        if (refreshResponse.statusCode == 201) {
          Map<String, dynamic> decodedResponse =
              jsonDecode(refreshResponse.body);
          await tokenStorage.storeAccessToken(decodedResponse['access_token']);
          await tokenStorage
              .storeRefreshToken(decodedResponse['refresh_token']);

          mutableHeaders["Authorization"] =
              'Bearer ${decodedResponse['access_token']}';
          return await simplePost(url, mutableHeaders, body);
        }
      }
      return response;
    } else {
      return await simplePost(url, mutableHeaders, body);
    }
  }

  static Future mainPut(String url, body,
      {Map<String, String>? headers}) async {
    final userController = Get.put(UserController(), permanent: true);
    final TokenStorage tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken() ?? "";
    var refreshToken = await tokenStorage.getRefreshToken() ?? "";

    Map<String, String> mutableHeaders =
        headers != null ? Map<String, String>.from(headers) : {};
    if (headers == null) {
      mutableHeaders['Content-Type'] = 'application/json';
    }

    if (accessToken.isNotEmpty) {
      mutableHeaders["Authorization"] = 'Bearer $accessToken';
      final response = await simplePut(url, mutableHeaders, body);

      if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshResponse = await refreshTokens(
            userController.user.value.email.value, refreshToken);
        if (refreshResponse.statusCode == 201) {
          Map<String, dynamic> decodedResponse =
              jsonDecode(refreshResponse.body);
          await tokenStorage.storeAccessToken(decodedResponse['access_token']);
          await tokenStorage
              .storeRefreshToken(decodedResponse['refresh_token']);

          mutableHeaders["Authorization"] =
              'Bearer ${decodedResponse['access_token']}';
          return await simplePut(url, mutableHeaders, body);
        }
      }
      return response;
    } else {
      return await simplePut(url, mutableHeaders, body);
    }
  }

  static Future mainDelete(String url) async {
    final userController = Get.put(UserController(), permanent: true);
    final TokenStorage tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken() ?? "";
    var refreshToken = await tokenStorage.getAccessToken() ?? "";

    if (accessToken != "") {
      final response =
          await simpleDelete(url, {'Authorization': 'Bearer $accessToken'});
      if (response.statusCode == 401) {
        final response = await refreshTokens(
            userController.user.value.email.value, refreshToken);
        if (response.statusCode == 201) {
          Map<String, dynamic> decodedResponse = jsonDecode(response.body);
          await tokenStorage.storeAccessToken(decodedResponse['access_token']);
          await tokenStorage
              .storeRefreshToken(decodedResponse['refresh_token']);
          return await simpleDelete(
              url, {'Authorization': 'Bearer $accessToken'});
        }
      }
      return (response);
    } else {
      return await simpleDelete(url, {'': ''});
    }
  }

  static Future mainMultiplePartPost(String url, String filepath) async {
    final userController = Get.put(UserController(), permanent: true);
    final TokenStorage tokenStorage = TokenStorage();
    var accessToken = await tokenStorage.getAccessToken() ?? "";
    var refreshToken = await tokenStorage.getAccessToken() ?? "";

    final response = await multiPart(
        url,
        {
          'Authorization': 'Bearer $accessToken',
          "Content-type": "multipart/form-data"
        },
        filepath);
    if (response.statusCode == 401) {
      final response = await refreshTokens(
          userController.user.value.email.value, refreshToken);
      if (response.statusCode == 201) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        await tokenStorage.storeAccessToken(decodedResponse['access_token']);
        await tokenStorage.storeRefreshToken(decodedResponse['refresh_token']);
        return (await multiPart(
            url,
            {
              'Authorization': 'Bearer $accessToken',
              "Content-type": "multipart/form-data"
            },
            filepath));
      }
    }
    return (response);
  }

  static refreshTokens(String email, String refreshToken) async {
    return await simplePost('/auth/refresh', {
      'Content-Type': 'application/x-www-form-urlencoded',
    }, {
      'email': email,
      'rt': refreshToken
    });
  }

  static simpleGet(String url, headers) async {
    return (await http.get(Uri.parse(dotenv.env['API_BACK_URL']! + url),
        headers: headers));
  }

  static simplePost(String url, headers, body) async {
    return (await http.post(Uri.parse(dotenv.env['API_BACK_URL']! + url),
        headers: headers, body: body));
  }

  static simplePut(String url, headers, body) async {
    return (await http.put(Uri.parse(dotenv.env['API_BACK_URL']! + url),
        headers: headers, body: body));
  }

  static simpleDelete(String url, headers) async {
    return (await http.delete(Uri.parse(dotenv.env['API_BACK_URL']! + url),
        headers: headers));
  }

  static multiPart(
      String url, Map<String, String> headers, String filepath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(dotenv.env['API_BACK_URL']! + url));

      var file = File(filepath);
      if (!await file.exists()) {
        print('File does not exist at path: $filepath');
        return null;
      }

      request.files.add(await http.MultipartFile.fromPath('file', filepath,
          contentType:
              MediaType('image', extension(filepath).replaceAll(".", ""))));
      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode != 201) {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return null;
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return null;
    }
  }
}

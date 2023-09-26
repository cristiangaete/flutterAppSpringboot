import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_springboot/services/dowmload_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class TodoService {
  static Future<List?> fetchTodos() async {
    const url = 'http://localhost:8080/estudents';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['resultado']['student'] as List<dynamic>;
      return result;
    } else {
      return null;
    }
  }

  static Future<void> domwloadCsv() async {
    DownloadService downloadService =
        kIsWeb ? WebDownloadService() : MobileDownloadService();
    await downloadService.download(
        url: 'http://localhost:8080/estudents/dowload-cvs');
  }

  static Future<bool> sendMail(Map body) async {
    const url = 'http://localhost:8080/estudents/enviar-correo';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return (response.statusCode == 200);
  }

  static Future<bool> addTodo(Map body) async {
    const url = 'http://localhost:8080/estudents';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return (response.statusCode == 200);
  }

  static Future<bool> updateTodo(int id, Map body) async {
    final url = 'http://localhost:8080/estudents/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return (response.statusCode == 200);
  }

  static Future<bool> deleteById(int id) async {
    final url = 'http://localhost:8080/estudents/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {
    html.window.open(url, "_blank");
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    var dir = await getApplicationDocumentsDirectory();

    String fileName = 'myFile';

    Dio dio = Dio();
    await dio.download(url, "${dir.path}/$fileName");

    OpenFile.open("${dir.path}/$fileName", type: 'application/pdf');
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}

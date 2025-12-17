import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'models/dashboard_module.dart';

class DashboardStorage {
  static const _fileName = 'dashboard_layout.json';

  static Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<void> save(List<DashboardModule> modules) async {
    final file = await _file();
    final jsonData = jsonEncode(modules.map((m) => m.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  static Future<List<DashboardModule>> load() async {
    final file = await _file();
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final List data = jsonDecode(content);

    return data.map((e) => DashboardModule.fromJson(e)).toList();
  }
}

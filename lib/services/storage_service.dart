import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/life_data.dart';

class StorageService {
  static const String _fileName = 'bravo_my_life_data.json';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<void> saveData(LifeData data) async {
    final file = File(await _getFilePath());
    final jsonString = jsonEncode(data.toJson());
    await file.writeAsString(jsonString);
  }

  Future<LifeData?> loadData() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (!await file.exists()) {
        return null;
      }
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return LifeData.fromJson(jsonMap);
    } catch (e) {
      // Return null if error (or handle corrupt file)
      print('Error loading data: $e');
      return null;
    }
  }

  Future<void> deleteData() async {
    final path = await _getFilePath();
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

import 'dart:io';
import 'dart:async' show Future;
import 'package:path_provider/path_provider.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class FileUtils {
  static Future readFile() async {
    try {
      // 获取本地文件目录，关键字await表示等待操作完成
      File file = await _getLocalFile('flutter.txt');
      // 使用给定的编码将整个文件内容读取为字符串
      String content = await file.readAsString();
      return content;
    } on FileSystemException {
      return "ERROR on read file";
    }
  }

  // 读取csv
  static Future readCsv() async {
    try {
      // 获取本地文件目录，关键字await表示等待操作完成
      File file = await _getFile('D:/SandBox/trunk/code/server/sandbox/data/csv', 'Quest.csv');
      // 使用给定的编码将整个文件内容读取为字符串
      String content = await file.readAsString();
      print('读取文件内容长度: ' + content.length.toString());
      return content;
    } on FileSystemException {
      return "ERROR on read file";
    }
  }

  // 获取本地文件目录
  static Future _getLocalFile(String fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return _getFile(dir, fileName);
  }

  // 获取指定目录文件
  static Future _getFile(String dir, String fileName) async {
    String path = '$dir/$fileName';
    print("获取文件路径: $path");
    return new File(path);
  }
}

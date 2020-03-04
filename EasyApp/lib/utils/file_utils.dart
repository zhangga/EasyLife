import 'dart:io';
import 'dart:async' show Future;
import 'package:path_provider/path_provider.dart';

/// Created by U-Demon
/// Date: 2020/3/4
class FileUtils {
  static Future readFile() async {
    try {
      // 获取本地文件目录，关键字await表示等待操作完成
      File file = await _getLocalFile();
      // 使用给定的编码将整个文件内容读取为字符串
      String content = await file.readAsString();
      return content;
    } on FileSystemException {
      return "ERROR on read file";
    }
  }

  // 获取本地文件目录
  static Future _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    // 返回本地文件目录
    return new File('$dir/counter.txt');
  }
}

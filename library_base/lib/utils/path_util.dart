import 'dart:io';
import 'package:library_base/utils/object_util.dart';
import 'package:path_provider/path_provider.dart';

///文件路径工具类
class PathUtils {
  PathUtils._internal();

  ///获取缓存目录路径
  static Future<String> getCacheDirPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  ///获取文件缓存目录路径
  static Future<String> getFilesDirPath() async {
    Directory directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  ///获取文档存储目录路径
  static Future<String> getDocumentsDirPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String?> getExternalFileDirPath() async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  static Future<String?> getExternalCacheDirPath() async {
    List<Directory>? directories = await getExternalCacheDirectories();

    if (ObjectUtil.isEmptyList(directories)) {
      return null;
    }

    return directories!.first.path;
    //return directories.map((e) => e.path).toList();
  }

  // 同步创建文件夹
  static Directory? createDirSync(String path) {
    if (ObjectUtil.isEmpty(path)) {
      return null;
    }

    Directory dir = new Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  // 异步创建文件夹
  static Future<Directory?> createDir(String path) async {
    if (ObjectUtil.isEmpty(path)) {
      return null;
    }

    Directory dir = new Directory(path);
    bool exist = await dir.exists();
    if (!exist) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Null> delDir(FileSystemEntity file, {bool onlyChild = false}) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    if (!onlyChild) {
      await file.delete();
    }
  }

  static Future getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  static String renderSize(double value) {
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}

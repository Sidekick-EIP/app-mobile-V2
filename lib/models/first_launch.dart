import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FirstLaunchUtil {
  static Future<bool> isFirstLaunch() async {
    final directory = await getApplicationDocumentsDirectory();
    final flagFile = File('${directory.path}/first_launch_flag.txt');

    bool isFirstTime = !await flagFile.exists();
    if (isFirstTime) {
      await flagFile.create();
    }
    return isFirstTime;
  }
}

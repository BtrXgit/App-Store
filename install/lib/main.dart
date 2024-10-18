import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APK Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DownloadAndInstallPage(),
    );
  }
}

class DownloadAndInstallPage extends StatefulWidget {
  @override
  _DownloadAndInstallPageState createState() => _DownloadAndInstallPageState();
}

class _DownloadAndInstallPageState extends State<DownloadAndInstallPage> {
  String apkUrl = 'https://www.dropbox.com/scl/fi/mhcdh33lnoh4ts6f4ygwt/Luca.apk?rlkey=d57m93e1gjfmz0cb62euqo9kd&st=jgc1ufru&dl=1';

  Future<String> downloadAPK(String url) async {
    try {
      debugPrint("Starting download from: $url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File apkFile = File('${directory.path}/Luca.apk');

        debugPrint("Saving APK to: ${apkFile.path}");
        await apkFile.writeAsBytes(response.bodyBytes);
        debugPrint("Download complete: ${apkFile.path}");
        return apkFile.path; // Return the path to the downloaded APK
      } else {
        debugPrint("Failed to download APK, status code: ${response.statusCode}");
        throw Exception('Failed to download APK');
      }
    } catch (e) {
      debugPrint("Error during download: $e");
      throw Exception('Error during download: $e');
    }
  }

  Future<void> downloadAndInstall() async {
    try {
      // Request permission to install packages
      var status = await Permission.requestInstallPackages.status;
      if (!status.isGranted) {
        status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          debugPrint("Permission denied for installing packages");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permission denied to install packages.")),
          );
          return;
        }
      }

      final apkPath = await downloadAPK(apkUrl);
      debugPrint("Opening APK for installation: $apkPath");
      final result = await OpenFile.open(apkPath);
      debugPrint("Open File Result: ${result.message}");
    } catch (e) {
      debugPrint("Error during installation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download and Install APK')),
      body: Center(
        child: ElevatedButton(
          onPressed: downloadAndInstall,
          child: Text('Download and Install App'),
        ),
      ),
    );
  }
}

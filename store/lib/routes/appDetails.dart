import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store/data/screenshots.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';

class AppDetails extends StatefulWidget {
  final String appImage;
  final String appName;
  final String appIcon;

  const AppDetails({
    required this.appImage,
    required this.appName,
    required this.appIcon,
    super.key,
  });

  @override
  State<AppDetails> createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  late String apkPath = '';
  bool isDownloaded = false;
  bool isInstalled = false;

  @override
  void initState() {
    super.initState();
    _initializeApkPath();
  }

  Future<void> _initializeApkPath() async {
    final tempDir = await getTemporaryDirectory();
    apkPath = '${tempDir.path}/app.apk';

    // Check if the APK already exists and update the state.
    final file = File(apkPath);
    if (await file.exists()) {
      setState(() {
        isDownloaded = true;
      });
    }

    // Also check if the app is already installed.
    await _checkIfAppIsInstalled();
  }

  Future<void> fetchAndDownloadApk() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      // Fetch the APK URL from Firestore.
      final doc = await FirebaseFirestore.instance
          .collection('Luca')
          .doc('latest')
          .get();
      final apkUrl = doc['apkUrl'] as String;

      // Check if the APK already exists before downloading.
      final file = File(apkPath);
      if (await file.exists()) {
        debugPrint("APK already exists: $apkPath");
        setState(() {
          isDownloaded = true;
        });
      } else {
        debugPrint("Starting APK download from: $apkUrl");

        // Download the APK using Dio with progress tracking.
        await Dio().download(
          apkUrl,
          apkPath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                downloadProgress = received / total;
              });
            }
          },
        );

        debugPrint("APK downloaded successfully: $apkPath");
        setState(() {
          isDownloaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error downloading APK: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download error: $e")),
      );
    } finally {
      setState(() {
        isDownloading = false;
        downloadProgress = 0.0;
      });
    }
  }

  Future<void> _checkIfAppIsInstalled() async {
    // Replace with your actual package name.
    final installed = await DeviceApps.isAppInstalled('com.example.app');
    setState(() {
      isInstalled = installed;
    });
  }

  Future<void> downloadAndInstallApk() async {
    if (!isDownloaded) {
      await fetchAndDownloadApk();
    } else if (!isInstalled) {
      await installApk();
    }

    // Check again if the app is installed after attempting the install.
    await _checkIfAppIsInstalled();
  }

  Future<void> installApk() async {
    if (apkPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "APK path is not set yet. Please download the APK first.")),
      );
      return;
    }

    try {
      // Request permission to install packages.
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

      debugPrint("Opening APK for installation: $apkPath");
      final result = await OpenFile.open(apkPath);
      debugPrint("Open File Result: ${result.message}");

      // After trying to install, check if the app is now installed.
      await _checkIfAppIsInstalled();
    } catch (e) {
      debugPrint("Error during installation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Installation error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("APK path: $apkPath");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      backgroundColor: const Color(0xff0f0e1c),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(widget.appImage),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          widget.appIcon,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.appName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Free'),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: isDownloading ? null : downloadAndInstallApk,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDownloading
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: isDownloading
                          ? Text(
                              'Downloading... ${(downloadProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Color(0xff0f0e1c),
                              ),
                            )
                          : Text(
                              isInstalled
                                  ? 'Open'
                                  : isDownloaded
                                      ? 'Install'
                                      : 'Download',
                              style: const TextStyle(
                                color: Color(0xff0f0e1c),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Overview'),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Play Fortnite Your Way',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'App Description',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: appScreenshots.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            appScreenshots[index],
                            fit: BoxFit.cover,
                            width: 300,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('App Info'),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About Info',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'INFORMATION',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'App Permissions',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

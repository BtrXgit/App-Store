import 'package:flutter/material.dart';
import 'package:store/routes/appDetails.dart';

List<String> appsImages = [
  'assets/screenshots/moonie.png',
  'assets/screenshots/1.png',
  'assets/screenshots/Luca.png',
  'assets/screenshots/1.png',
];

List<String> appIcons = [
  'assets/moonie.png',
  'assets/luca.png',
  'assets/luca.png',
  'assets/luca.png',
];

List<String> appNames = [
  'Moonie',
  'Luca',
  'Infinity',
  'Inspirio',
];

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0e1c),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _appBar(context),
              Expanded(
                child: ListView.builder(
                    itemCount: appIcons.length,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AppDetails(
                                appImage: appsImages[index],
                                appName: appNames[index],
                                appIcon: appIcons[index],
                              ),
                            ),
                          );
                        },
                        child: _listApps(
                            context: context,
                            imageUrl: appsImages[index],
                            appIcon: appIcons[index],
                            appName: appNames[index]),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 34,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "STORE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
    ),
  );
}

Widget _listApps({
  required BuildContext context,
  required String imageUrl,
  required String appIcon,
  required String appName,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
    child: Container(
      height: 238, // Adjusted height to avoid overflow
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 170,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    appIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    appName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle install action
                      },
                      child: const Text(
                        "Install",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      "In-app purchases",
                      style: TextStyle(fontSize: 8),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

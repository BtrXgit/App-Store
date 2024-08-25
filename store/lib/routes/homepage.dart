import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

List<String> appsImages = [
  'https://cdn2.unrealengine.com/fortnite-og-social-1920x1080-a5adda66fab9.jpg',
  'https://media.newyorker.com/photos/590977c9019dfc3494ea2f7f/master/pass/Johnston-Clash-Clans.jpg',
  'https://cdn2.unrealengine.com/egs-fallguys-mediatonic-g1a-00-1920x1080-75b891d04ff9.jpg',
  'https://hyperpc.ae/images/support/articles/pc-for-gta-5/article-gta-5-banner.jpg',
];

List<String> appIcons = [
  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Fortnite_F_lettermark_logo.png',
  'https://play-lh.googleusercontent.com/LByrur1mTmPeNr0ljI-uAUcct1rzmTve5Esau1SwoAzjBXQUby6uHIfHbF9TAT51mgHm',
  'https://cdn2.steamgriddb.com/icon/5d7bc0a1b56b6b05df25ba38b98ca60d.png',
  'https://e7.pngegg.com/pngimages/392/551/png-clipart-grand-theft-auto-five-illustration-grand-theft-auto-v-grand-theft-auto-san-andreas-gta-5-online-gunrunning-playstation-4-mod-gta-miscellaneous-emblem.png',
];

List<String> appNames = [
  'Fortnite',
  'Clash of Clans',
  'Fall Guys',
  'GTA 5',
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
                      return _listApps(
                          context: context,
                          imageUrl: appsImages[index],
                          appIcon: appIcons[index],
                          appName: appNames[index]);
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
              height: 30,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Store",
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
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
                  child: CachedNetworkImage(
                    imageUrl: appIcon,
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

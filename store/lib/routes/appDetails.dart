import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppDetails extends StatefulWidget {
  final String appImage;
  final String appName;
  final String appIcon;
  const AppDetails(
      {required this.appImage,
      required this.appName,
      required this.appIcon,
      super.key});

  @override
  State<AppDetails> createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      backgroundColor: Color(0xff0f0e1c),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: widget.appImage),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: widget.appIcon,
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
            Text('Free'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Install',
                  style: TextStyle(
                    color: Color(0xff0f0e1c),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

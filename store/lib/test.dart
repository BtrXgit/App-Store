import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

class LofiMusicPlayer extends StatefulWidget {
  @override
  _LofiMusicPlayerState createState() => _LofiMusicPlayerState();
}

class _LofiMusicPlayerState extends State<LofiMusicPlayer> {
  final String folderUrl = 'https://lofigirl.com/wp-content/uploads/2024/01/';
  List<String> mp3Urls = [];
  List<String> mp3Names = [];
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchMp3Files();
  }

  Future<void> _fetchMp3Files() async {
    try {
      final response = await http.get(Uri.parse(folderUrl));
      if (response.statusCode == 200) {
        final body = response.body;
        final regex = RegExp(r'href="([^"]+\.mp3)"');
        final matches = regex.allMatches(body);
        setState(() {
          mp3Urls =
              matches.map((match) => folderUrl + match.group(1)!).toList();
          mp3Names =
              matches.map((match) => path.basename(match.group(1)!)).toList();
        });
      }
    } catch (e) {
      print('Failed to fetch MP3 files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lofi Music Player')),
      body: ListView.builder(
        itemCount: mp3Urls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mp3Names[index]),
            onTap: () async {
              await _audioPlayer.setUrl(mp3Urls[index]);
              _audioPlayer.play();
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(home: LofiMusicPlayer()));
}

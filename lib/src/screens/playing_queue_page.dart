import 'package:flutter/material.dart';
import 'package:flutter_music_player/src/load_files.dart';

class PlayingQueuePage extends StatefulWidget {
  const PlayingQueuePage({super.key});

  @override
  State<PlayingQueuePage> createState() => _PlayingQueuePageState();
}

class _PlayingQueuePageState extends State<PlayingQueuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左寄せにする
        children: [
          const Text("次に再生"),
          if(playingQueueList.isNotEmpty) Text(playingQueueList[0].musicName)
          else const Text("再生キューは空です"),
          const Divider(),
          for(var item in playingQueueList) ...{
            Text(item.musicName),
          }
        ]
      ),
    );
  }
}
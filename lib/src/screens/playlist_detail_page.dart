import 'package:flutter/material.dart';
import 'package:flutter_music_player/src/load_files.dart';

class PlaylistDetailPage extends StatefulWidget {
  // const playlistDetailPage({super.key});
  final Playlist playlistObject;
  // playlistDetailPage(this.playlistName);
  const PlaylistDetailPage({Key? key, required this.playlistObject}) : super(key: key);

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {

  final popupmenuItems = ["削除", "再生キューに追加"];

  Future<void> makePlaylistDialog(BuildContext context) async {
    String _playlistName = "";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新しいプレイリストを作成"),
          content: TextField(
            decoration: const InputDecoration(hintText: "プレイリスト名を入力"),
            onChanged: (text) {
              _playlistName = text;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("ok"),
              onPressed: () {
                debugPrint(_playlistName);
                setState(() {
                  playlistMap.addEntries([MapEntry(_playlistName, Playlist(_playlistName))]);
                  widget.playlistObject.playlistItems.add(_playlistName);
                  outputPlaylists();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  Future<void> removeConfirmation(BuildContext context, String _playlistName) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("本当に削除しますか？"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  playlistMap.remove(_playlistName);
                  outputPlaylists();
                });
                Navigator.pop(context);
              }, 
              child: const Text("Yes"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistObject.playlistName),
      ),
      body: Column(
        children: [
          const Text("playlist"),
          const Divider(thickness: 1,),
          for(var value in widget.playlistObject.playlistItems) ...{
            Row(children: [
              TextButton(
                child: Text("$value"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PlaylistDetailPage(playlistObject :playlistMap[value]!),
                  ));
                },
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return popupmenuItems.map((String list) {
                    return PopupMenuItem(
                      value: list,
                      child: Text(list)
                    );
                  }).toList();
                },
                onSelected: (String selectedItem) {
                  setState(() {
                    if(selectedItem == "削除") {
                      debugPrint("削除");
                      removeConfirmation(context, value);
                      //playlistMap.remove("${value.getPlaylistName()}");
                    } else if(selectedItem == "再生キューに追加") {
                      debugPrint("再生キューに追加");
                    }
                  });
                },
              ),
            ],),
            const Divider(thickness: 1,),
          },
          const Text("music"),
          const Divider(thickness: 1,),
          for(int i = 0; i < widget.playlistObject.musicItems.length; i++) ...{
            
          }
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("フローティングアクションボタン");
          makePlaylistDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
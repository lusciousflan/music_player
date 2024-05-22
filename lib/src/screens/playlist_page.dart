import 'package:flutter/material.dart';
import 'package:flutter_music_player/src/screens/playlist_detail_page.dart';
import '../load_files.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final popupmenuItems = ["削除", "再生キューに追加"];
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
                  playlistMap.remove("$_playlistName");
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
                  playlistMap.addEntries([MapEntry(_playlistName, Playlist(_playlistName, true))]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.white.withOpacity(0.0),
      //   elevation: 0.0,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左寄せにする
        children: [
          for (var value in playlistMap.values) ...{
            // テキストじゃないところをタップしてもプレイリストの中身のページに遷移したい
            if(value.isParent) ...{
              Row(children: [
                TextButton(
                  child: Text(value.playlistName),
                  onPressed: () {
                    debugPrint(value.playlistName);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PlaylistDetailPage(playlistObject :value),
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
                        removeConfirmation(context, value.playlistName);
                        //playlistMap.remove("${value.getPlaylistName()}");
                      } else if(selectedItem == "再生キューに追加") {
                        debugPrint("再生キューに追加");
                      }
                    });
                  },
                ),
              ],),
            },
            if(value.isParent) ...{
              const Divider(thickness: 1,),
            }
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
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// グローバルな変数の定義はここ

/*
プレイリストが満たす要件
・プレイリストはプレイリストと楽曲を内包する
・楽曲、プレイリストの追加、削除ができる
・プレイリストのページでソートができる
・プレイリスト名はプレイリスト保存時に使用する記号などは使えないようにする

楽曲が満たす要件
・楽曲は名前などを取得して表示できる
・タグをつけられる

プレイリストの保存
playlist:プレイリスト名
(
引数
)
{
playlist:プレイリスト名
...
path:曲のパス
path:曲のパス
...
}

楽曲はパスとその他情報が紐づくように別ファイルで保存　→　全曲スキャン時に更新
*/
class Playlist {
  String _playlistName = "";
  bool _isParent = false;
  List<String> _playlistItems = [];
  List<String> _musicItems = [];

  Playlist(this._playlistName, [this._isParent = false]); // プレイリスト名に:を使えないようにする

  String get playlistName => _playlistName;
  List get playlistItems => _playlistItems;
  List get musicItems => _musicItems;
  bool get isParent => _isParent;

  set isParent(bool p) {
    _isParent = p;
  }

  void addMucic(String x) {
    _musicItems.add(x);
  }
  void addPlaylist(String x) {
    _playlistItems.add(x);
  }
}

class Music {
  String _musicName = "";
  String _path = "";
  Set<String> _tags = {};

  Music(this._path);

  String get path => _path;
  String get musicName => _musicName;

  void playMusic() {
    debugPrint("play");
  }
}

Map<String, Playlist> playlistMap = {}; // プレイリストの名前とオブジェクト本体をマップで管理
Map<String, Music> musicMap = {}; // 同上　曲のパスと実態をマップで管理
List<Music> playingQueueList = [];

// ディレクトリの読み込み
Future<String> get applicationDocumentsPath async {
  final directory = await getApplicationDocumentsDirectory();
  debugPrint("directory path is ${directory.path}");
  return directory.path;
}

Future<String> get externalStorageDirectryPath async {
  final directory = await getExternalStorageDirectory();
  debugPrint("external directory path is ${directory!.path}");
  return directory.path;
}

void loadfiles() async {
  // themeColor = Colors.red;
  if(Platform.isAndroid) {
    debugPrint("Androidです");
    // final Future<Directory> tmpdir = getApplicationSupportDirectory();
    // final path = tmpdir.path;
    final appDocumentPath = await applicationDocumentsPath;
    debugPrint(appDocumentPath);
    final playlistsFile = File("$appDocumentPath/playlists.txt");
    final musicsFile = File("$appDocumentPath/musics.txt");
    if(!await playlistsFile.exists()) {
      await playlistsFile.create();
      // await file.writeAsString("");
    }
    if(!await musicsFile.exists()) {
      await musicsFile.create();
    }
    if(await playlistsFile.exists()) {
      // deleteFiles("$/hoge.txt"); // 消す時だけ使う
      // await file.writeAsString(await file.readAsString() +  "\ntesttest\nyeah\nhoge\nhuga"); // 書きたす
      final data = await playlistsFile.readAsString();
      List tmp  = data.split("\n");
      print(tmp);
      String mode = "playlistName", nowPlaylistName = "";
      bool nowIsParent = false;
      for(var item in tmp) {
        if(item == "") break;
        debugPrint(item + "  " + mode);
        if(item == "(") {
          mode = "arg";
          continue;
        }
        if(item == ")") {
          // mode = ")";
          playlistMap.addEntries([MapEntry(nowPlaylistName, Playlist(nowPlaylistName, nowIsParent))]);
          continue;
        }
        if(item == "{") {
          mode = "items";
          continue;
        }
        if(item == "}") {
          mode = "playlistName";
          continue;
        }
        if(mode == "playlistName") {
          nowPlaylistName = item.split(":")[1];
          mode = "(";
        } else if(mode == "arg") {
          if(item == ")") {
            // mode = ")";
          } else {
            final datamember = item.split(":");
            if(datamember[0] == "isParent") {
              // playlistMap["$nowPlaylistName"].isParent = datamember[1];
              // nowIsParent = datamember[1];
              if(datamember[1] == "true") {
                nowIsParent = true;
              } else {
                nowIsParent = false;
              }
            }
          }
        } else if(mode == "items") {
          if(item == "}") {
            // mode = "}";
          }
          final datamember = item.split(":");
          if(datamember.length == 2) { 
            if(datamember[0] == "playlist") {
              playlistMap[nowPlaylistName]?.addPlaylist(datamember[1]);
            } else if(datamember[0] == "music") {
              playlistMap[nowPlaylistName]?.addMucic(datamember[1]);
            }
          }
        }
      }
    }
    fullScan();
    print(playlistMap);
  }
}

// 端末内のファイルを全部スキャンして楽曲データを探す
void fullScan() async {
  if(Platform.isAndroid) {
    final externalDirectoryPath = await externalStorageDirectryPath;
    debugPrint(externalDirectoryPath);
    Directory tmp = Directory("/storage/");
    print(tmp.parent);
    // Directory? directory = await getExternalStorageDirectory();
    // var systemTempDir = Directory.systemTemp;
    // var dirlist = directory?.listSync();
    // print(dirlist);
    // print(directory.list({bool recursive = false , bool followLinks = true}));
    // for(var entity = 0; entity < dirlist.length; entity++) {

    // }
    // await for (var entity in tmp.list(recursive: false, followLinks: false)) {
    //   print(entity.path);
    // }
  }
}

void deleteFiles(String filepath) async {
  final file = File(filepath);
  if(await file.exists()) {
    await file.delete();
  }
}

void outputPlaylists() async {
  final appDocumentPath = await applicationDocumentsPath;
  debugPrint(appDocumentPath);
  final file = File("$appDocumentPath/playlists.txt");
  if(!await file.exists()) {
    await file.create();
  }
  await file.writeAsString("");
  for(var value in playlistMap.values) { 
    await file.writeAsString("${await file.readAsString()}playlist:${value.playlistName}\n(\nisParent:${value.isParent}\n)\n{\n");
    for(var item in value.playlistItems) {
      await file.writeAsString("${await file.readAsString()}playlist:$item\n");
    }
    for(var item in value.musicItems) {
      await file.writeAsString("${await file.readAsString()}music:${item.path}\n");
    }
    await file.writeAsString("${await file.readAsString()}}\n");
  }
  final data = await file.readAsString();
  List tmp  = data.split("\n");
  print(tmp);
  debugPrint(data);
}

void resetPlaylists() async {
  final appDocumentPath = await applicationDocumentsPath;
  final file = File("$appDocumentPath/playlists.txt");
  if(await file.exists()) {
    file.writeAsString("");
  }
  playlistMap = {};
  loadfiles();
}

// https://computer.sarujincanon.com/2022/11/20/select_music_flutter/
// 音楽再生について
import 'package:flutter/material.dart';
import 'src/screens/playlist_page.dart';
import 'src/screens/music_page.dart';
import 'src/screens/playing_queue_page.dart';
import 'src/load_files.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      home: const MyHomePage(title: 'Music Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  static const List<Widget> widgetOptions = <Widget>[
    PlaylistPage(),
    MusicPage(),
    PlayingQueuePage(),
  ];
  final menuList = ["プレイリストをリセット", "設定", "画面のリフレッシュ"];

  @override
  void initState() { // アプリ起動時に1回だけ実行される
    debugPrint("welcome to the music player!");
    setState(() {
      loadfiles();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widgetOptions.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Music Player"),
          bottom: TabBar(
            // isScrollable: true,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            tabs: const [
              Tab(text: "PlayList"),
              Tab(text: "Music"),
              Tab(text: "Playing Queue"),
            ],
            // indicatorColor: Colors.white,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Music Player',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: Colors.black,
              ),
              ...menuList.map(
                (e) => listTile(e),
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: widgetOptions.elementAt(currentPageIndex)
                ),
              )
            ],
          ),
        ),
    ),);
  }
  Widget listTile(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  debugPrint(title);
                  if(title == "プレイリストをリセット") {
                    setState(() {
                      resetPlaylists();
                    });
                  } else if(title == "設定") {
                  } else if(title == "画面のリフレッシュ") {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context) => super.widget)
                    );
                  } else {
                    debugPrint("error!");
                  }
                },
                icon: const Icon(Icons.arrow_circle_right),
              )
            ],
          ),
        ),
        const Divider(
          thickness: 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}

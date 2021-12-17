import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

String query = "PewDiePie";
late List<YouTubeVideo> videoResult;
String youTubeKey = dotenv.env['YOUTUBE_API_KEY'].toString();
int max = 50;
YoutubeAPI ytApi = YoutubeAPI(youTubeKey, maxResults: max, type: "channel");
String topYoutubeVideo = "";
String botYoutubeVideo = "";
var rng = Random();
Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  await dotenv.load(fileName: ".env");
  //...runapp

  videoResult = await ytApi.search(query);

  getVideos(videoResult);

  runApp(const GameApp());
}

void getVideos(videoResult) {
  int v1 = rng.nextInt(max);
  int v2 = rng.nextInt(max);
  String checkQueryVideo1 = videoResult[v1].kind.toString().toLowerCase();
  String checkQueryVideo2 = videoResult[v2].kind.toString().toLowerCase();

  if (checkQueryVideo1 == "video" || checkQueryVideo2 == "video") {
    topYoutubeVideo = videoResult[v1].thumbnail.medium.url.toString();
    botYoutubeVideo = videoResult[v2].thumbnail.medium.url.toString();
  }

  while (checkQueryVideo1 != "video" || checkQueryVideo2 != "video") {
    v1 = rng.nextInt(max);
    v2 = rng.nextInt(max);
    checkQueryVideo1 = videoResult[v1].kind.toString().toLowerCase();
    checkQueryVideo2 = videoResult[v2].kind.toString().toLowerCase();

    topYoutubeVideo = videoResult[v1].thumbnail.medium.url.toString();
    botYoutubeVideo = videoResult[v2].thumbnail.medium.url.toString();
  }
}

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GameApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const HomePageWidget(
        key: null,
      ),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _score = 0;

  void _incrementSCore() {
    setState(() {
      _score++;
    });
    getVideos(videoResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      topYoutubeVideo,
                      scale: 1,
                    ),
                  ),
                ),
                const Text("12386 Likes"),
                const Text(
                  'Is Higher or Lower than:',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    elevation: 1.5,
                    backgroundColor: Colors.white10,
                    shape: const StadiumBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      "appIcons/arrow.png",
                      color: Colors.black,
                    ),
                    splashColor: Colors.black54,
                    onPressed: () {
                      print("PRESSED UP");
                      _incrementSCore();
                    },
                  ),
                ),
                Text('Score: $_score'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    elevation: 1.5,
                    backgroundColor: Colors.white10,
                    shape: const StadiumBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Image.asset(
                        "appIcons/arrow.png",
                        color: Colors.black,
                      ),
                    ),
                    splashColor: Colors.black54,
                    onPressed: () {
                      print("PRESSED DOWN");
                      _incrementSCore();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      botYoutubeVideo,
                      scale: 1,
                    ),
                  ),
                ),
                const Text("1234 Likes"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

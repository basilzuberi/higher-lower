import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

String query = "Fireship";
late List<YouTubeVideo> videoResult;
String youTubeKey = dotenv.env['YOUTUBE_API_KEY'].toString();
int max = 50;
YoutubeAPI ytApi = YoutubeAPI(youTubeKey, maxResults: max, type: "channel");
String strTopYoutubeVideoLink = "";
String strBotYoutubeVideoLink = "";
String strTopYoutubeVideoLikes = "";
String strBotYoutubeVideoLikes = "";
String strTopVideoID = "";
String strBotVideoID = "";
var rng = Random();
Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  await dotenv.load(fileName: ".env");
  //...runapp

  videoResult = await ytApi.search(query);

  getVideos(videoResult);
  strTopYoutubeVideoLikes = await getVideoStats(youTubeKey, strTopVideoID);
  strBotYoutubeVideoLikes = await getVideoStats(youTubeKey, strBotVideoID);

  runApp(const GameApp());
}

getVideoStats(String apikey, String id) async {
  String likeCount = "";
  // This query gets the like counts for a video
  await http
      .get(Uri.parse(
          "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$id&key=$apikey"))
      .then((value) {
    final response = value;
    if (response.statusCode == 200) {
      likeCount = json
          .decode(response.body)['items'][0]['statistics']['likeCount']
          .toString();
    } else if (response.statusCode == 403) {
      likeCount = "-1";
    }
  });
  strTopYoutubeVideoLikes = "-1";
  return likeCount;
}

void returnStats() async {
  strTopYoutubeVideoLikes = await getVideoStats(youTubeKey, strTopVideoID);
  strBotYoutubeVideoLikes = await getVideoStats(youTubeKey, strBotVideoID);
}

void getVideos(videoResult) {
  int v1 = rng.nextInt(max);
  int v2 = rng.nextInt(max);
  String checkQueryVideo1 = videoResult[v1].kind.toString().toLowerCase();
  String checkQueryVideo2 = videoResult[v2].kind.toString().toLowerCase();

  if (checkQueryVideo1 == "video" || checkQueryVideo2 == "video") {
    strTopYoutubeVideoLink = videoResult[v1].thumbnail.medium.url.toString();
    strBotYoutubeVideoLink = videoResult[v2].thumbnail.medium.url.toString();
    strTopVideoID = videoResult[v1].id;
    strBotVideoID = videoResult[v2].id;
    returnStats();
  }

  while (checkQueryVideo1 != "video" || checkQueryVideo2 != "video") {
    v1 = rng.nextInt(max);
    v2 = rng.nextInt(max);
    checkQueryVideo1 = videoResult[v1].kind.toString().toLowerCase();
    checkQueryVideo2 = videoResult[v2].kind.toString().toLowerCase();

    strTopYoutubeVideoLink = videoResult[v1].thumbnail.medium.url.toString();
    strBotYoutubeVideoLink = videoResult[v2].thumbnail.medium.url.toString();

    strTopVideoID = videoResult[v1].id;
    strBotVideoID = videoResult[v2].id;
    returnStats();
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

  void _incrementScore(String state) {
    int topLikes = int.parse(strTopYoutubeVideoLikes);
    int botLikes = int.parse(strBotYoutubeVideoLikes);
    setState(() {
      if ((state == "up" && topLikes >= botLikes) ||
          (state == "down" && botLikes >= topLikes)) {
        _score++;
      } else {
        _score = 0;
      }
    });

    getVideos(videoResult);
  }

  _showErrorToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(
            'API Error, Try Again Later... MAXIMUM Queries Attempted'),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // strTopYoutubeVideoLikes="-1";
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Videos for: $query',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
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
                      strTopYoutubeVideoLink,
                      scale: 1,
                    ),
                  ),
                ),
                (strTopYoutubeVideoLikes == "-1")
                    ? _showErrorToast(context)
                    : Text('$strTopYoutubeVideoLikes Likes'),
                const Text(
                  'Which Has More Likes:',
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
                      _incrementScore("up");
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
                      _incrementScore("down");
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
                      strBotYoutubeVideoLink,
                      scale: 1,
                    ),
                  ),
                ),
                const Text('???? Likes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

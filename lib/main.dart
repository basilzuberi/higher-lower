import 'package:flutter/material.dart';

void main() => runApp(const GameApp());

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://picsum.photos/seed/44/600',
                      scale: 3,
                    ),
                  ],
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
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://picsum.photos/seed/44/600',
                      scale: 3,
                    ),
                  ],
                ),
              ),
              const Text("1234 Likes"),
            ],
          ),
        ),
      ),
    );
  }
}

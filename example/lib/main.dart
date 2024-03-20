import 'package:cached_gif/gif.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final GifController controller1, controller2, controller3;
  int _fps = 30;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    controller3 = GifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('ImageProviders'),
              ),
              Tab(
                child: Text('Manage'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              clipBehavior: Clip.none,
              children: <Widget>[
                const Text('AssetImage (original fps, loop)'),
                Gif(
                  autostart: Autostart.loop,
                  placeholder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  image: const AssetImage('assets/rick.gif'),
                ),
                const Text('NetworkImage (30 fps, once)'),
                Gif(
                  fps: 30,
                  autostart: Autostart.once,
                  placeholder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  image: const NetworkImage(
                      'https://i.giphy.com/media/Ju7l5y9osyymQ/giphy.webp'),
                ),
                const Text('NetworkImage (20 seconds, once)'),
                Gif(
                  controller: controller2,
                  duration: const Duration(seconds: 20),
                  autostart: Autostart.once,
                  placeholder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  image: const NetworkImage(
                      'https://i.giphy.com/media/Ju7l5y9osyymQ/giphy.webp'),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Gif(
                  controller: controller3,
                  fps: _fps,
                  image: const AssetImage('assets/rick.gif'),
                ),
                AnimatedBuilder(
                  animation: controller3,
                  builder: (BuildContext context, Widget? child) {
                    return Slider(
                      label: 'Timeline',
                      value: controller3.value,
                      onChanged: (v) => setState(() {
                        controller3.value = v;
                      }),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        controller3.repeat();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        controller3.stop();
                      },
                    ),
                  ],
                ),
                Slider(
                  label: _fps.toString(),
                  value: _fps.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 4,
                  onChanged: (v) => setState(() {
                    controller3.stop();
                    _fps = v.round();
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

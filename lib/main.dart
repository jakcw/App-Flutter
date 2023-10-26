import 'package:baby_app/feed_screen.dart';
import 'package:baby_app/history_screen.dart';
import 'package:baby_app/measure_screen.dart';
import 'package:baby_app/nappy_screen.dart';
import 'package:baby_app/sleep_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'entry.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\n\nConnected to Firebase App ${app.options.projectId}\n\n");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (context) => EntryModel(),
    child: MaterialApp(
      title: 'Baby Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    ),
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
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home'), // Add the page heading here
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
              
                        const Text('Feeding', style: TextStyle(fontSize: 18),),
                        Image.asset(
                          'assets/images/feed.png',
                          width: 50,
                          height: 50,
                          color: Colors.white
                        ),
                      ],
                    ),),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SleepScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    
                        const Text('Sleep', style: TextStyle(fontSize: 18),),
                        Image.asset(
                          'assets/images/sleep.png',
                          width: 50,
                          height: 50,
                          color: Colors.white
                        ),
                      ],
                    ),
                  )),
                  Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NappyScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    
                        const Text('Nappy change', style: TextStyle(fontSize: 18),),
                        Image.asset(
                          'assets/images/nappy.png',
                          width: 50,
                          height: 50,
                          color: Colors.white
                        ),
                      ],
                    ),
                  )),
              
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MeasureScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    
                        const Text('Measurements', style: TextStyle(fontSize: 18),),
                        Image.asset(
                          'assets/images/measurement.png',
                          width: 50,
                          height: 50,
                          color: Colors.white
                        ),
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen(title: 'History')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    
                        const Text('History', style: TextStyle(fontSize: 18),),
                        Image.asset(
                          'assets/images/history.png',
                          width: 50,
                          height: 50,
                          color: Colors.white
                        ),
                      ],
                    ),
                  )),
            ]),
      ),
    );
  }
}

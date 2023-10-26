import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'entry.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int sharedValue = 0;
  late Timer timer;
  String timerString = "00:00:00";
  int seconds = 0;
  bool isRunning = false;
  String feedType = "left";

  final notesController = TextEditingController();

  void updateFeedType(int sharedValue) {
    if (sharedValue == 0) {
      feedType = 'Left';
    } else if (sharedValue == 1) {
      feedType = 'Right';
    } else {
      feedType = 'Bottle';
    }
  }


  // timer help - https://stackoverflow.com/questions/59425969/how-to-run-a-timer-in-initstate-flutter
  // https://api.flutter.dev/flutter/dart-async/Timer/Timer.periodic.html
  
  @override
  void initState() {
    super.initState();
    startFeed();
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  void startFeed() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRunning) {
        setState(() {
          seconds++;
          int hrs = seconds ~/ 3600;
          int mins = seconds ~/ 60 % 60;
          int secs = seconds % 60;
          // formatting timer - https://stackoverflow.com/questions/54610121/flutter-countdown-timer
          timerString =
              "${hrs.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        title: const Text('Feeding'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: 70.0),
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSlidingSegmentedControl<int>(
                children: const <int, Widget>{
                  0: SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      'Left',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  1: SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      'Right',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  2: SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      'Bottle',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                },
                onValueChanged: (int? value) {
                  setState(() {
                    sharedValue = value!;
                  });
                },
                groupValue: sharedValue,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              timerString,
              style: TextStyle(fontSize: 42, color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                    });
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 40)),
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        timerString = "00:00:00";
                        isRunning = false;
                        seconds = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(fixedSize: Size(80, 40)),
                    child: const Text('Reset'))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: 'Notes (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                minLines: 8,
                maxLines: 8,
                onChanged: (value) {
                },
              ),
            ),
            SizedBox(
              height: 80,
            ),
            ElevatedButton(
                onPressed: () async {
                  updateFeedType(sharedValue);
                  Entry entry = Entry(
                      startTime: Timestamp.fromDate(DateTime.now()),
                      category: "feed",
                      feedType: feedType,
                      duration: TimeSpan(
                          hours: seconds ~/ 3600,
                          minutes: seconds ~/ 60 % 60,
                          seconds: seconds % 60),
                      notes: notesController.text);

                  await Provider.of<EntryModel>(context, listen: false)
                      .add(entry);
                      
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}

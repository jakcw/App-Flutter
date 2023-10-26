import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  String startTime = DateTime.now().toString();
  String endTime = DateTime.now().toString();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sleep'),
      ),
      body: Center(
          child: Column(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 22.0, top: 40.0),
              child: Text('Start Sleep'),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(22, 10, 22, 0),
              child: DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) => setState(() {
                  startTime = val;
                }),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 22.0, top: 50.0),
              child: Text('End sleep'),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(22, 10, 22, 0),
              child: DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) => setState(() {
                  endTime = val;
                }),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 90.0),
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
              // Handle the text change
            },
          ),
        ),
        SizedBox(height: 70.0),
        ElevatedButton(onPressed: () async {
                  var dur = DateTime.parse(endTime).difference(DateTime.parse(startTime));
                  // getting seconds from duration - https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
                  Entry entry = Entry(
                      startTime: Timestamp.fromDate(DateTime.parse(startTime)),
                      endTime: Timestamp.fromDate(DateTime.parse(endTime)),
                      duration: TimeSpan(hours: dur.inSeconds ~/ 3600,
                      minutes: dur.inSeconds ~/ 60 % 60,
                      seconds: dur.inSeconds % 60),
                      category: "sleep",
                      notes: notesController.text);
                  await Provider.of<EntryModel>(context, listen: false)
                      .add(entry);  
                  Navigator.pop(context);
                }, child: const Text('Save'))
      ])),
    );
  }
}

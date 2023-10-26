import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EditSleepScreen extends StatefulWidget {
  final String? id;
  const EditSleepScreen({Key? key, this.id}) : super(key: key);

  @override
  State<EditSleepScreen> createState() => _EditSleepScreenState();
}

class _EditSleepScreenState extends State<EditSleepScreen> {
  String startTime = '';
  String endTime = '';
  var feedType;
  Entry? entry;

  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // provider in here so we can access the entry values
    entry = Provider.of<EntryModel>(context, listen: false).get(widget.id);
    startTime = entry!.startTime!.toDate().toString();
    endTime = entry!.endTime!.toDate().toString();
    notesController.text = entry?.notes ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit sleep'),
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
                initialValue: startTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (time) => setState(() {
                  startTime = time;
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
                initialValue: endTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (time) => setState(() {
                  endTime = time;
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
        ElevatedButton(
            onPressed: () async {
              var dur =
                  DateTime.parse(endTime).difference(DateTime.parse(startTime));
              entry?.duration = TimeSpan(
                  hours: dur.inSeconds ~/ 3600,
                  minutes: dur.inSeconds ~/ 60 % 60,
                  seconds: dur.inSeconds % 60);
              entry?.notes = notesController.text;
              entry?.startTime = Timestamp.fromDate(DateTime.parse(startTime));
              entry?.endTime = Timestamp.fromDate(DateTime.parse(endTime));
              entry?.feedType = feedType;
              await Provider.of<EntryModel>(context, listen: false)
                  .updateItem(widget.id!, entry!);

              Navigator.pop(context);
            },
            child: const Text('Save'))
      ])),
    );
  }
}

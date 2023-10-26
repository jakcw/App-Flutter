import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'entry.dart';

class EditNappyScreen extends StatefulWidget {
  final String? id;
  const EditNappyScreen({Key? key, this.id}) : super(key: key);

  @override
  State<EditNappyScreen> createState() => _EditNappyScreenState();
}

class _EditNappyScreenState extends State<EditNappyScreen> {
  int sharedValue = 0;
  String selectedDate = DateTime.now().toString();
  var nappyType;
  Entry? entry;

  final notesController = TextEditingController();
  final dateController = TextEditingController();

  void updateNappyType(int sharedValue) {
    if (sharedValue == 0) {
      nappyType = 'Wet';
    } else if (sharedValue == 1) {
      nappyType = 'Dirty';
    } else {
      nappyType = 'Both';
    }
  }

  @override
  void initState() {
    super.initState();
    entry = Provider.of<EntryModel>(context, listen: false).get(widget.id);
    if (entry?.nappyType == 'Wet') {
      sharedValue = 0;
    } else if (entry?.nappyType == 'Dirty') {
      sharedValue = 1;
    } else {
      sharedValue = 2;
    }
    selectedDate = entry!.startTime!.toDate().toString();
    notesController.text = entry?.notes ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit nappy'),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 22.0, top: 50.0),
                  child: Text(
                    'Date and time',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(22, 5, 22, 0),
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => setState(() {
                      selectedDate = val;
                    }),
                  ),
                ),
              ],
            ),
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
                      'Wet',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  1: SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      'Dirty',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  2: SizedBox(
                    height: 40,
                    child: Center(
                        child: Text(
                      'Both',
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
            SizedBox(height: 20),
            ElevatedButton.icon(
            
              onPressed: () async {
                // downloading images - https://firebase.google.com/docs/storage/flutter/download-files
                // and - https://stackoverflow.com/questions/50877398/flutter-load-image-from-firebase-storage
                final storageRef = FirebaseStorage.instance.ref();
                final pathRef = storageRef.child("entries/${widget.id}.jpeg");
                var url = await pathRef.getDownloadURL();

                // Show as popup - https://stackoverflow.com/questions/60047676/flutter-display-photo-or-image-as-modal-popup
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        width: 440,
                        height: 400,
                        child: Image.network(url, fit: BoxFit.cover),
                      
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.camera_alt),
              label: Text('View photo'),
            ),
            Container(
              margin: EdgeInsets.only(top: 80.0),
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
                  updateNappyType(sharedValue);
                  entry?.notes = notesController.text;
                  entry?.startTime =
                      Timestamp.fromDate(DateTime.parse(selectedDate));
                  entry?.nappyType = nappyType;

                  await Provider.of<EntryModel>(context, listen: false)
                      .updateItem(widget.id!, entry!);
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}

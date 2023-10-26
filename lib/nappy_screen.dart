import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class NappyScreen extends StatefulWidget {
  const NappyScreen({super.key});

  @override
  State<NappyScreen> createState() => _NappyScreenState();
}

class _NappyScreenState extends State<NappyScreen> {
  XFile? image;
  int sharedValue = 0;
  var nappyType = 'Wet';
  String selectedDate = DateTime.now().toString();

  final notesController = TextEditingController();
  

  Future<void> pickImage() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 1);
  }
  

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Nappy change'),
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
                    initialValue: DateTime.now().toString(),
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
              // Used as reference for all my segmented controls - https://api.flutter.dev/flutter/cupertino/CupertinoSegmentedControl-class.html
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text('Add photo'),
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
            SizedBox(height: 40.0),
            ElevatedButton(
                onPressed: () async {
                  updateNappyType(sharedValue);
                  Entry entry = Entry(
                      startTime:
                          Timestamp.fromDate(DateTime.parse(selectedDate)),
                      category: "nappy",
                      nappyType: nappyType,
                      notes: notesController.text);

                  // create document reference so we can upload image with same id as the entry
                  DocumentReference docRef =
                      await Provider.of<EntryModel>(context, listen: false)
                          .add(entry);


                  // if the image has been picked we will try and upload it - https://firebase.google.com/docs/storage/flutter/upload-files
                  // and - https://stackoverflow.com/questions/51857796/flutter-upload-image-to-firebase-storage
                  if (image != null) {
                    File file = File(image!.path);
                    try {
                        FirebaseStorage.instance
                          .ref('entries/' + docRef.id + '.jpeg')
                          .putFile(file);
                          print("photo added");
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}

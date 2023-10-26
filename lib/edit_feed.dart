
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'entry.dart';

class EditFeedScreen extends StatefulWidget {
  final String? id;
  const EditFeedScreen({Key? key, this.id}) : super(key: key);

  @override
  State<EditFeedScreen> createState() => _EditFeedScreenState();
}

class _EditFeedScreenState extends State<EditFeedScreen> {
  int sharedValue = 0;
  String selectedDate = '';
  var feedType;
  Entry? entry;

  final notesController = TextEditingController();
  final hrsController = TextEditingController();
  final minsController = TextEditingController();
  final secsController = TextEditingController();

  void updateFeedType(int sharedValue) {
    if (sharedValue == 0) {
      feedType = 'Left';
    } else if (sharedValue == 1) {
      feedType = 'Right';
    } else {
      feedType = 'Bottle';
    }
  }

  @override
  void initState() {
    super.initState();
    entry = Provider.of<EntryModel>(context, listen: false).get(widget.id);
    if (entry?.feedType == 'Left') {
      sharedValue = 0;
    } else if (entry?.feedType == 'Right') {
      sharedValue = 1;
    } else {
      sharedValue = 2;
    }
    selectedDate = entry!.startTime!.toDate().toString();
    notesController.text = entry?.notes ?? "";
    hrsController.text = entry?.duration?.hours.toString() ?? "";
    minsController.text = entry?.duration?.minutes.toString() ?? "";
    secsController.text = entry?.duration?.seconds.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit feed'),
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
                    timeLabelText: 'Hour',
                    onChanged: (val) => setState(() {
                      selectedDate = val;
                    }),
                  ),
                ),
              ],
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSlidingSegmentedControl<int>(
                children: const <int, Widget>{
                  0: SizedBox(
                    height: 50,
                    child: Center(
                        child: Text('Left', style: TextStyle(fontSize: 16))),
                  ),
                  1: SizedBox(
                    height: 50,
                    child: Center(
                        child: Text('Right', style: TextStyle(fontSize: 16))),
                  ),
                  2: SizedBox(
                    height: 50,
                    child: Center(
                        child: Text('Bottle', style: TextStyle(fontSize: 16))),
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
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 295,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: hrsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Hrs',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder:  OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2.0),
                                
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: minsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Mins',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),

                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2.0),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: secsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Secs',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2.0),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
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
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () async {
                updateFeedType(sharedValue);
                entry?.notes = notesController.text;
                entry?.startTime =
                    Timestamp.fromDate(DateTime.parse(selectedDate));
                entry?.feedType = feedType;
                entry?.duration = TimeSpan(
                    hours: int.parse(hrsController.text),
                    minutes: int.parse(minsController.text),
                    seconds: int.parse(secsController.text));

                await Provider.of<EntryModel>(context, listen: false)
                    .updateItem(widget.id!, entry!);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}



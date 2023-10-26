import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'entry.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeasureScreen extends StatefulWidget {
  const MeasureScreen({super.key});

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  double currentWeightValue = 20;
  double currentHeightValue = 20;

  String selectedDate = DateTime.now().toString();

  final notesController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Measurements'),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(50, 40.0, 50, 0),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date of measurement',
              timeLabelText: "Hour",
              onChanged: (val) => setState(() {
                  selectedDate = val;
                }),
            ),
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 50), child: Text("Height (cm)")),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                //Slider help - https://stackoverflow.com/questions/71509956/how-do-i-get-the-value-from-slider-in-the-textbox-in-flutter
                child: Slider(
                    value: currentHeightValue,
                    min: 20,
                    max: 150,
                    divisions: 100,
                    label: currentHeightValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentHeightValue = value;
                        heightController.text = value.round().toString();
                      });
                    }),
              ),
              // remove padding https://stackoverflow.com/questions/53644897/how-do-i-remove-content-padding-from-textfield
              Container(
                margin: EdgeInsets.only(left: 50),
                width: 60,
                child: TextField(
                  controller: heightController,
                  readOnly: true,
                  style: const TextStyle(
                    fontSize: 15, // Small font size
                  ),
                  decoration: InputDecoration(
                    hintText: 'cm',
                    isDense: true, // Added this
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 5), // Less padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (String value) {
                      setState(() {
                       currentHeightValue = double.parse(value);
                       if (currentHeightValue >= 150) {
                        currentHeightValue = 150;
                       }
                       if (currentHeightValue <= 20) {
                        currentHeightValue = 20;
                       }

                      });

                  },
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 50), child: Text("Weight (kg)")),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Slider(
                    value: currentWeightValue,
                    min: 5,
                    max: 60,
                    divisions: 100,
                    label: currentWeightValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentWeightValue = value;
                        weightController.text = value.round().toString();

                      });
                    }),
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                width: 60,
                child: TextField(
                  controller: weightController,
                  readOnly: true,
                  style: const TextStyle(
                    fontSize: 15, 
                  ),
                  decoration: InputDecoration(
                    hintText: "kg",
                    isDense: true, 
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 5), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (String value) {
                      setState(() {
                       currentWeightValue = double.parse(value);
                    
                      });

                  },
                ),
              )
            ],
          ),
          Container(
          margin: EdgeInsets.only(top: 40.0),
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
        SizedBox(height: 20.0),
        ElevatedButton(onPressed: () async {
          Entry entry = Entry(
            startTime: Timestamp.fromDate(DateTime.parse(selectedDate)),
            category: "measurement",
            height: double.parse(heightController.text),
            weight: double.parse(weightController.text),
            notes: notesController.text

          );

          await Provider.of<EntryModel>(context, listen: false)
                      .add(entry); 
          Navigator.pop(context);
        }, 
        child: const Text('Save'))

        ],
      )),
    );
  }
}

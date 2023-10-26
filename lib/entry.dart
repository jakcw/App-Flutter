import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Entry {
  late String id;
  Timestamp? startTime;
  Timestamp? endTime;
  Timestamp? date;
  TimeSpan? duration;
  String? notes;
  String? feedType;
  double? height;
  double? weight;
  String? nappyType;
  String category;

  Entry({
    this.startTime,
    this.endTime,
    this.date,
    this.duration,
    this.notes,
    this.feedType,
    this.height,
    this.weight,
    this.nappyType,
    required this.category,
  });

  Entry.fromJson(Map<String, dynamic> json, this.id)
      : startTime = json['startTime'],
        endTime = json['endTime'],
        date = json['date'],
        duration = json['duration'] != null
            ? TimeSpan.fromJson(json['duration'])
            : null,
        notes = json['notes'],
        feedType = json['feedType'],
        height = json['height'],
        weight = json['weight'],
        nappyType = json['nappyType'],
        category = json['category'];

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'date': date,
        'duration': duration?.toJson(),
        'notes': notes,
        'feedType': feedType,
        'height': height,
        'weight': weight,
        'nappyType': nappyType,
        'category': category,
      };
}

class TimeSpan {
  late int hours;
  late int minutes;
  late int seconds;

  TimeSpan({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  TimeSpan.fromJson(Map<String, dynamic> json)
      : hours = json['hours'],
        minutes = json['minutes'],
        seconds = json['seconds'];

  Map<String, dynamic> toJson() => {
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
      };
}

class EntryModel extends ChangeNotifier {
  final List<Entry> items = [];

  CollectionReference entryCollection =
      FirebaseFirestore.instance.collection('entries');

  bool loading = false;

  EntryModel() {
    fetch();
  }

  Future fetch() async {
    items.clear();
    loading = true;

    notifyListeners();

    var querySnapshot =
        await entryCollection.orderBy("startTime", descending: true).get();
    for (var doc in querySnapshot.docs) {
      var entry = Entry.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(entry);
    }


    loading = false;
    update();
  }

  Future add(Entry item) async {
    loading = true;
    update();
    // did it like this so I could print out the documentid like
    DocumentReference docRef = await entryCollection.add(item.toJson());
    await fetch();
    print("Document added with ID: " + docRef.id);

    return docRef;
    // just for debugging
  }

  Future updateItem(String id, Entry item) async {
    loading = true;
    update();

    await entryCollection.doc(id).set(item.toJson());

    await fetch();
  }

  Entry? get(String? id) {
    if (id == null) return null;
    return items.firstWhere((entry) => entry.id == id);
  }

  // the await code and fetch was making the screen reload each time I deleted an entry so I removed it
  // it still seems to work fine, not sure if this is a bad way of doing things tho
  Future delete(String id) async {
    entryCollection.doc(id).delete();
  }

  void update() {
    notifyListeners();
  }
}

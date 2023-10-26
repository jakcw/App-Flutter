import 'package:baby_app/edit_feed.dart';
import 'package:baby_app/edit_nappy.dart';
import 'package:baby_app/edit_sleep.dart';
import 'package:flutter/material.dart';
import 'entry.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntryModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, EntryModel entryModel, _) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              if (entryModel.loading)
                const CircularProgressIndicator()
              else
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (_, index) {
                        var entry = entryModel.items[index];
                        // deletion of items - https://docs.flutter.dev/cookbook/gestures/dismissible
                        // and - https://www.youtube.com/watch?v=AzOONgeCVKg&ab_channel=Codepur
                        if (entry.category == 'feed') {
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (_) {
                              setState(() {
                                Provider.of<EntryModel>(context, listen: false)
                                    .delete(entry.id);
                                entryModel.items.removeAt(index);
                              });
                            },
                            key: Key(entry.id),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/feed.png',
                                width: 40,
                                height: 40,
                              ),
                              trailing: Image.asset(
                                  'assets/images/right-chevron.png',
                                  height: 25,
                                  width: 25),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Feed - ${entry.feedType} on ${DateFormat('d MMMM').format(entry.startTime!.toDate())}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  if (entry.duration != null)
                                    Text(
                                        'Duration: ${entry.duration?.hours.toString()} hrs, ${(entry.duration?.minutes.remainder(60)).toString()} mins, ${(entry.duration?.seconds.remainder(60)).toString()} secs',
                                        style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              subtitle: Text('Notes: ${entry.notes}'),

                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  print(entry.id);
                                  return EditFeedScreen(id: entry.id);
                                }));
                              }, 
                            ),
                          );
                        } else if (entry.category == 'measurement') {
                          return ListTile(
                            leading: Image.asset(
                              'assets/images/measurement.png',
                              width: 40,
                              height: 40,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Measurement - ${DateFormat('d MMMM').format(entry.startTime!.toDate())}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                    'Height: ${entry.height}cm, Weight: ${entry.weight}kg',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            subtitle: Text(
                                'Notes: ${entry.notes}'),
                          );
                        } else if (entry.category == 'nappy') {
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (_) {
                              setState(() {
                                Provider.of<EntryModel>(context, listen: false)
                                    .delete(entry.id);
                                entryModel.items.removeAt(index);
                              });
                            },
                            key: Key(entry.id),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/nappy.png',
                                width: 40,
                                height: 40,
                              ),
                              trailing: Image.asset(
                                  'assets/images/right-chevron.png',
                                  height: 25,
                                  width: 25),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nappy change - ${DateFormat('d MMMM, h:mm a').format(entry.startTime!.toDate())}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    entry.nappyType.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              subtitle: Text('Notes: ${entry.notes}'),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  print(entry.id);
                                  return EditNappyScreen(id: entry.id);
                                }));
                              },
                            ),
                          );
                        } else if (entry.category == 'sleep') {
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                            ),
                            onDismissed: (_) {
                              setState(() {
                                Provider.of<EntryModel>(context, listen: false)
                                    .delete(entry.id);
                                entryModel.items.removeAt(index);
                              });
                            },
                            key: Key(entry.id),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/sleep.png',
                                width: 40,
                                height: 40,
                              ),
                              trailing: Image.asset(
                                  'assets/images/right-chevron.png',
                                  height: 25,
                                  width: 25),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sleep on ${DateFormat('d MMMM, h:mm a').format(entry.startTime!.toDate())}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Slept for: ${entry.duration?.hours.toString()} hrs, ${(entry.duration?.minutes.remainder(60)).toString()} mins, ${(entry.duration?.seconds.remainder(60)).toString()} secs',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              subtitle: Text('Notes: ${entry.notes}'),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  print(entry.id);
                                  return EditSleepScreen(id: entry.id);
                                }));
                              },
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text('Entry not found'),
                          );
                        }
                      },
                      itemCount: entryModel.items.length),
                )
            ],
          ),
        ));
  }
}

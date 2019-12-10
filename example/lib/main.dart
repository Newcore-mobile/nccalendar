///
///Author: YoungChan
///Date: 2019-12-10 11:35:13
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 14:52:45
///Description: nccalendar example
///
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nccalendar/nccalendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _singleDT = '';
  String _multiDT = '';

  void _showSingleMode(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return NCCalendar(
            isDateRangeMode: false,
            onDateSelected: (dt) {
              Navigator.of(ctx).pop();
              setState(() {
                _singleDT = DateFormat('yyyy.MM.dd').format(dt);
              });
            },
          );
        });
  }

  void _showMultiMode(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return NCCalendar(
            isDateRangeMode: true,
            onDateRangeSelected: (st, et) {
              Navigator.of(ctx).pop();
              setState(() {
                _multiDT =
                    '${DateFormat('yyyy.MM.dd').format(st)} - ${DateFormat('yyyy.MM.dd').format(et)}';
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日历'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  OutlineButton(
                    child: Text('单选模式'),
                    onPressed: () {
                      _showSingleMode(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(_singleDT),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      _showMultiMode(context);
                    },
                    child: Text('多选模式'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(_multiDT),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

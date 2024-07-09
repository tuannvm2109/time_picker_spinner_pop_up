import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Picker Spinner Pop Up',
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MyHomePage(title: 'Time Picker Spinner Pop Up'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 30,
            top: 60,
            child: TimePickerSpinnerPopUp(
              mode: CupertinoDatePickerMode.time,
              initTime: DateTime.now(),
              minTime: DateTime.now().subtract(const Duration(days: 10)),
              maxTime: DateTime.now().add(const Duration(days: 10)),
              barrierColor: Colors.black12, //Barrier Color when pop up show
              minuteInterval: 1,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              cancelText: 'Cancel',
              confirmText: 'OK',
              enable: true,
              radius: 10,
              pressType: PressType.singlePress,
              timeFormat: 'dd/MM/yyyy',
              // Customize your time widget
              // timeWidgetBuilder: (dateTime) {},
              locale: const Locale('vi'),
              onChange: (dateTime) {
                // Implement your logic with select dateTime
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/views/home.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main()async {

  await Hive.initFlutter();

  await Hive.openBox('transaction');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,

    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.purple,
    )
    ),
      home: const HomePage(),
    );
  }
}

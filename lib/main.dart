import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workmanager/workmanager.dart';
import 'screen/upload_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
bool uploadFfileWithScheduleTime = false;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simplePeriodicTask:
        var dio = Dio();
          dynamic temp = inputData;
          FormData data = FormData.fromMap({
            'mediaUrl': await MultipartFile.fromFile(temp['normalpath'],
                filename: temp['encodedpath']),
            'mediaType': temp['type'],
          });
          var response =
              await dio.post("https://apiv2.bemeli.com/taskapi/postCreate", data: data);
        uploadFfileWithScheduleTime = true;
        break;
    }

    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         backgroundColor: Colors.transparent),
      home: const UploadImage(),
    );
  }
}





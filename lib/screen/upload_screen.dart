import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import 'dart:async';
import '../main.dart';
import '../services/notification_services.dart';
import '../widget/button_widget.dart';
import '../widget/grid_widget.dart';
import '../widget/image_widget.dart';
import '../widget/upload_status_widget.dart';
import 'view_screen.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  
  List<File>? imageFileList = [];
  List<dynamic> documents = [];
  List<String> type = [];
  bool fileSelected = false;
  final NotificationServices _notificationServices = NotificationServices();
  double? percent;
  dynamic selectTime;
  dynamic selectTimeValue = 0;
  bool secheduleTime = false;
    final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  String status = "Waiting...";
  @override
  void initState() {
    _notificationServices.initialisationSet();
    checkRealtimeConnection();
    super.initState();
  }

    void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        status = "Connected";
      } else {
        status = "Not Connected";
        Fluttertoast.showToast(
            msg: "No internet connection please check!!! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
   _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('widget $imageFileList');
    return WillPopScope(
      onWillPop: ()async{
      final show = await showAlert(context);
  return show;
      } ,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Center(
                child: Text(
                  "U",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
          leadingWidth: 60,
          titleSpacing: 0,
          title: InkWell(
            onTap: (){
              upload();
            },
            child: const Text(
              
              'UPLOAD',
              style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            const Center(
                child: Text(
              'View',
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontStyle: FontStyle.italic),
            )),
            IconButton(
              icon: const Icon(
                Icons.view_agenda,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ViewScreen()));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (!fileSelected)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Upload the Images and Videos from your Gallery to store your Memories in the CLOUD. ',
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 3,
                        height: 1.7,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (!fileSelected)
                SizedBox(
                  height: 350,
                  child: Image.asset('assets/file.gif'),
                ),
              if (fileSelected && imageFileList!.length == 1)
                SingleImage(imageFileList: imageFileList),
              if (fileSelected && imageFileList!.length > 1)
                GridImage(imageFileList: imageFileList),
              const SizedBox(
                height: 10,
              ),
               if (fileSelected &&  !secheduleTime)
               const SizedBox(
                width: 300,
                 child: Text(
                          "Choose your Scehudle time to upload the file to the server or you can upload directly without scedhule :"),
               ),
               if (fileSelected &&  !secheduleTime)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: "minutes",
                          child: Text("minutes"),
                        ),
                      ],
                      hint: Text(
                        selectTime ?? "select your field",
                        style: const TextStyle(color: Colors.black),
                      ),
                      onChanged: (val) {
                        setState(() {
                          selectTime = val;
                        });
                      }),
                  DropdownButton<int>(
                      items: const [
                        DropdownMenuItem<int>(
                          value: 15,
                          child: Text("15"),
                        ),
                        DropdownMenuItem<int>(
                          value: 20,
                          child: Text("20"),
                        ),
                        DropdownMenuItem<int>(
                          value: 30,
                          child: Text("30"),
                        ),
                      ],
                      hint: Text(
                        selectTimeValue == 0
                            ? "select value"
                            : selectTimeValue.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onChanged: (val) {
                        setState(() {
                          selectTimeValue = val;
                        });
                      }),
                ],
              ),
              if (percent != null && percent != 100.0)
                UploadStatus(percent: percent),
              if (percent != null && percent == 100.0)
                const Text(
                  'File is uploaded completely',
                  style: TextStyle(color: Colors.green),
                ),
              const SizedBox(
                height: 5,
              ),
               if (selectTime != null && selectTimeValue == 0 &&! secheduleTime)
                    const Text(
                      'Please select value',
                      style: TextStyle(color: Colors.red),
                    ),
                     if (selectTime == null && selectTimeValue != 0)
                    const Text(
                      'Please select field',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                height: 5,
              ),
               if (secheduleTime)
                  Text(
                    "Scehudle time uploading is done and it will uplaod after $selectTimeValue miutes",
                    style: const TextStyle(color: Colors.blue),
                  ),

              Text(fileSelected
                  ? 'You can clear the file and upload the next file'
                  : 'Select the single or multi file to upload'),
              const SizedBox(
                height: 5,
              ),
             
             
              ButtonWidget(
                text: fileSelected ? "Clear" : "Select the file",
                onClicked: () {
                  if (fileSelected) {
                    clear();
                  } else {
                    selectImg();
                  }
                },
                icon: fileSelected ? Icons.clear : Icons.attach_file,
              ),
            ],
          ),
        ),
        floatingActionButton: (fileSelected && percent == null)
            ? FloatingActionButton(
                onPressed: () {
                  fileUpload();
                },
                backgroundColor: Colors.black,
                tooltip: 'Upload the file',
                child: const Icon(Icons.cloud_upload_outlined),
              )
            : Container(),
      ),
    );
  }

  Future<dynamic> showAlert(BuildContext context) {
    return showDialog(
  context: context,
  builder: (context) =>  AlertDialog(
    title:  const Text('Are you sure?'),
    content:  const Text('Do you want to exit an App'),
    actions: <Widget>[
     GestureDetector(
        onTap: () => Navigator.of(context).pop(false),
        child: const Text("NO"),
      ),
      const SizedBox(height: 16),
   GestureDetector(
        onTap: () {
          Navigator.of(context).pop(true);
          clear();
        } ,
        child: const Text("YES"),
      ),
    ],
  ),

);
  }

  Future selectImg() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        imageFileList = result.paths.map((path) => File(path!)).toList();
        fileSelected = true;
      });
    //   final path = result.files.single.path!;

    // setState(() => file = File(path));

    print(imageFileList);

    } else {
      setState(() {
        fileSelected = false;
      });
    }
  }

Future fileUpload() async{
  if (status == 'Not Connected') {
      Fluttertoast.showToast(
          msg: "No internet connection please check ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (selectTimeValue != 0 &&
        selectTime != null &&
        secheduleTime == false) {
          for (int i = 0; i < imageFileList!.length; i++) {
      var path = imageFileList![i].path;
      if (path.split('/').last.contains('jpg') ||path.split('/').last.contains('jpeg') || path.split('/').last.contains('png')) {
        type.add('image');
      } else if(path.split('/').last.contains('mp4')) {
        type.add('video');
      }else{
        type.add('unknow');
      }
      Workmanager().registerPeriodicTask(
        simplePeriodicTask,
        simplePeriodicTask,
        frequency: Duration(minutes: selectTimeValue),
        inputData: {
          'normalpath': path,
          'encodedpath':path.split('/').last,
          'type': type,
        },
      );
      }

      setState(() {
        secheduleTime = true;
      });
    }else{
        upload();
    }
}

  Future upload() async {
    var dio = Dio();
    for (int i = 0; i < imageFileList!.length; i++) {
      var path = imageFileList![i].path;
      if (path.split('/').last.contains('jpg') ||path.split('/').last.contains('jpeg') || path.split('/').last.contains('png')) {
        type.add('image');
      } else if(path.split('/').last.contains('mp4')) {
        type.add('video');
      }else{
        type.add('unknow');
      }
      documents.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last));
    }
    
    FormData data = FormData.fromMap({
       'mediaType': type,
      'mediaUrl':documents
    });

    var response = await dio.post("https://apiv2.bemeli.com/taskapi/postCreate", data: data,
        onSendProgress: (int sent, int total) {
      setState(() {
        percent = ((sent / total) * 100);
      });

      final value = percent! / 10;
      setState(() {
        _notificationServices.sendNotification("file uploading",
            '${documents.length.toString()} - files', value.toInt());
      });
      
    });

    if(response.statusCode==200){
print(response.statusCode);
    }else{
      print(response);
    }

    
  }

 

  clear() {
     Workmanager().cancelAll();
    setState(() {
      fileSelected = false;
      imageFileList = [];
      documents= [];
      type=[];
      percent = null;
      selectTime = null;
      selectTimeValue = 0;
      secheduleTime = false;
    });
  }
}

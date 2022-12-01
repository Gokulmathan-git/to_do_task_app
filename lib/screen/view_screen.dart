import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:to_do_task_app/screen/video.dart';
import 'package:to_do_task_app/widget/button_widget.dart';
import 'package:video_player/video_player.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  dynamic data;
  late VideoPlayerController _videoPlayerController;
  int loadMore = 10;
  bool loading = false;

  @override
  void initState() {
    //futureAlbum = fetchPhotos();
    loading = true;
    super.initState();
    getHttp();
  }

  getHttp() async {
    print('inside');
    var response =
        await http.get(Uri.parse('https://apiv2.bemeli.com/taskapi/getdatas'));

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        data = items;
        loading = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Failed to get data from the server...! ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Gallery',
            style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            if (loading)
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        body: 
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: data == null ? 0 : loadMore,
                    itemBuilder: (BuildContext context, int index) {
                      final rev = data.reversed.toList();
                      final assetsType = rev[index]['mediaType'];
                      final assetsFile = rev[index]['mediaUrl'];
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (assetsType == 'image' &&
                                (assetsFile.toString().contains('jpg') ||
                                    assetsFile.toString().contains('jpeg') ||
                                    assetsFile.toString().contains('png')))
                              Card(
                                elevation: 20,
                                shadowColor: Colors.black,
                                margin: const EdgeInsets.all(20),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.network(
                                    assetsFile,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            if (assetsType == 'video' &&
                                assetsFile.toString().contains('mp4'))
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VideoTile(
                                            video: assetsFile,
                                            networkFile: true,
                                          )));
                                },
                                child: Card(
                                    elevation: 20,
                                    shadowColor: Colors.black,
                                    margin: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Image.asset('assets/Video.jpg'),
                                        const Text('Video file click to view'),
                                      ],
                                    )),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (data != null)
                    ButtonWidget(
                        icon: Icons.more,
                        onClicked: () {
                          setState(() {
                            loadMore = loadMore + 10;
                          });
                        },
                        text: 'show More'),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
        ),
        );
  }
}

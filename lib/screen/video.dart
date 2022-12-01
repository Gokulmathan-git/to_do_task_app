import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class VideoTile extends StatefulWidget {
  const VideoTile({Key? key, this.video,required this.networkFile,this.video1}) : super(key: key);
  final String? video;
  final File? video1;
  final bool networkFile;


  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _videoController;
  late Future initializeVideo;

  @override
  void initState() {
    if(widget.networkFile){
_videoController = VideoPlayerController.network(widget.video!);
    }else{
      _videoController = VideoPlayerController.file(widget.video1!);
    }
    
    initializeVideo = _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.play();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title:const Text('Video Player', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Colors.black,
          ),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: initializeVideo,
          builder: (context , snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return GestureDetector(onTap: (){
                setState(() {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            });
              },child: VideoPlayer(_videoController));
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingleImage extends StatefulWidget {
  const SingleImage({
    Key? key,
    required this.imageFileList,
  }) : super(key: key);

  final List<File>? imageFileList;

  @override
  State<SingleImage> createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(widget.imageFileList![0])
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool type = false;
    final fileFormat = widget.imageFileList![0].path.split('/').last;
    if (fileFormat.toString().contains('mp4')) {
      type = true;
    } else {
      type = false;
    }
    return (type && _videoPlayerController.value.isInitialized)
        ? video()
        : image();
  }


  AspectRatio video() {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: GestureDetector(
        child: VideoPlayer(_videoPlayerController),
        onTap: () {
          setState(() {
            if (_videoPlayerController.value.isPlaying) {
              _videoPlayerController.pause();
            } else {
              _videoPlayerController.play();
            }
          });
        },
      ),
    );
  }


  Center image() {
    return Center(
          child: Container(
            color: Colors.grey,
            height: 440,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: Image.file(
                    widget.imageFileList![0],
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'File name: ${widget.imageFileList![0].path.split('/').last}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
  }
}

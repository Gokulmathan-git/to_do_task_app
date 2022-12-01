import 'dart:io';

import 'package:flutter/material.dart';

import '../screen/video.dart';

class GridImage extends StatelessWidget {
  const GridImage({
    Key? key,
    required this.imageFileList,
  }) : super(key: key);

  final List<File>? imageFileList;

  @override
  Widget build(BuildContext context) {
    bool type = false;

    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemCount: imageFileList!.length,
      itemBuilder: ((context, index) {
        final fileFormate = imageFileList![index].path.split('/').last;
        if (fileFormate.toString().contains('mp4')) {
          type = true;
        } else {
          type = false;
        }
        return type
            ? InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoTile(
                            video1: imageFileList![index],
                            networkFile: false,
                          )));
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child:  Column(
                      children: [
                        Image.asset(
                          'assets/Video.jpg',
                          fit: BoxFit.fill,
                        ),
                        const Text('Video file click to view'),
                      ],
                    ),
                  
                ),
              )
            : Container(
                color: Colors.grey,
                margin: const EdgeInsets.all(10),
                child: Image.file(
                  imageFileList![index],
                  fit: BoxFit.fill,
                ),
              );
      }),
    );
  }
}

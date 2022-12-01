import 'package:flutter/material.dart';

class UploadStatus extends StatelessWidget {
  const UploadStatus({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final double? percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            maxRadius: 10,
            backgroundColor: Colors.white,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("Uploading....."),
          Text('(${percent!.toStringAsFixed(1)})%'),
        ],
      ),
    );
  }
}
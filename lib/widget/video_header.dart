//作者详情widget

import 'package:flutter/material.dart';
import 'package:flutter_bilbil_app/model/video_model.dart';
import 'package:flutter_bilbil_app/util/color.dart';
import 'package:flutter_bilbil_app/util/format_util.dart';

class VideoHeader extends StatelessWidget {
  final Owner owner;

  const VideoHeader({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  owner.face,
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(
                      owner.name,
                      style: TextStyle(
                          fontSize: 13,
                          color: primary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${countFormat(owner.fans)}粉丝',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
          MaterialButton(
            onPressed: () {
              print("---关注---");
            },
            color: primary,
            minWidth: 50,
            height: 24,
            child: Text(
              '+关注',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VideoPlayCard2 extends StatefulWidget {
  final int id;
  final String videoLink;

  const VideoPlayCard2({
    super.key,
    required this.id,
    required this.videoLink,
  });

  @override
  VideoPlayCard2State createState() => VideoPlayCard2State();
}

class VideoPlayCard2State extends State<VideoPlayCard2> {
  bool isVideoLoading = true;
  late File videoFile;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  loadVideo() async {
    try {
      File cacheFile = await DefaultCacheManager().getSingleFile(widget.videoLink);
      videoFile = cacheFile;

      _controller = VideoPlayerController.file(cacheFile);
      await _controller.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        autoInitialize: false,
        aspectRatio: 16 / 9,
      );

      isVideoLoading = false;
      setState(() {});
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: isVideoLoading
          ? Container(
              width: MediaQuery.sizeOf(context).width,
              color: Colors.black,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.white),
            )
          : Chewie(
              key: Key("chewie-key-${widget.id}"),
              controller: _chewieController,
            ),
    );
  }
}

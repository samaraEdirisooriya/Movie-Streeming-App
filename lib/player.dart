import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithQualityOptions extends StatefulWidget {
  const VideoPlayerWithQualityOptions({super.key});

  @override
  _VideoPlayerWithQualityOptionsState createState() =>
      _VideoPlayerWithQualityOptionsState();
}

class _VideoPlayerWithQualityOptionsState
    extends State<VideoPlayerWithQualityOptions> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  List<String> qualityOptions = [
    "https://vz-37aa8c85-08a.b-cdn.net/d608ff1c-ccb7-4082-9566-cdc13d40b8d6/play_240p.mp4",
    "https://vz-17f4a0ba-a3f.b-cdn.net/d608ff1c-ccb7-4082-9566-cdc13d40b8d6/play_360p.mp4",
    "https://vz-17f4a0ba-a3f.b-cdn.net/d608ff1c-ccb7-4082-9566-cdc13d40b8d6/play_480p.mp4"
  ];

  Duration? _latestPosition; // Variable to store the latest position

  @override
  void initState() {
    super.initState();
    _initializePlayer(qualityOptions[0]);
  }

  void _initializePlayer(String videoUrl) {
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      startAt: _latestPosition, // Set the start position
    );
  }

  void _changeQuality(String newUrl) {
    _videoPlayerController!.pause();
    _latestPosition =
        _videoPlayerController!.value.position; // Store the latest position
    _videoPlayerController!.dispose();
    setState(() {
      _initializePlayer(newUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player with Quality Options'),
      ),
      body: Center(
        child: _chewieController != null
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
      persistentFooterButtons: qualityOptions
          .map(
            (url) => ElevatedButton(
              onPressed: () {
                _changeQuality(url);
              },
              child: Text("Quality ${qualityOptions.indexOf(url) + 1}"),
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    print("discorpedssssssssssssssssss");
  }
}

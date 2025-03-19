import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie/home.dart';
import 'package:movie/nav_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:miniplayer/miniplayer.dart';

class SearchTile extends StatelessWidget {
  final CustomVideo video;
  final bool hasPadding;
  final VoidCallback? onTap;


  const SearchTile(
      {Key? key,
      required this.video,
      this.hasPadding = false,
      this.onTap,
})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late VideoPlayerController videoController;
    return GestureDetector(
      onTap: () {
       
        String videoid = video.guid;
        print('video.guid$videoid gggggggggggggggggggg ggg');
        context.read(boolclos).state = true;
        context.read(videoPlayerControllerProvider).state?.dispose();
        videoController = VideoPlayerController.network(
          "https://vz-37aa8c85-08a.b-cdn.net/$videoid/playlist.m3u8",
        )..initialize().then((_) {
            // setState to update the state provider with the initialized video controller
            context.read(videoPlayerControllerProvider).state = videoController;
            context.read(boolclos).state = false;
          });
        context
            .read(miniPlayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MAX);

        print('1 done');
        context.read(selectedVideoProvider).state = video;
      },
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Text(video.title))
        ],
      ),
    );
  }
}

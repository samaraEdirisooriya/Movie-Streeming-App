import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie/home.dart';
import 'package:movie/nav_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import 'package:timeago/timeago.dart' as timeago;

class PlaylistCard extends StatelessWidget {
  final CustomVideo video;
  final bool hasPadding;
  final VoidCallback? onTap;
  
  const PlaylistCard({
    Key? key,
    required this.video,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);



  @override
  
  Widget build(BuildContext context) {
    late VideoPlayerController videoController;
    String videosid = video.thumb;
    String vidioguid = video.guid;
    int tim = video.length;
    Duration duration = Duration(seconds: tim);
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int remainingSeconds = duration.inSeconds % 60;

    String formattedDuration =
        '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    timeago.setLocaleMessages('en', timeago.EnMessages()); // Set the locale

    String timestampString = video.dateTime.toString();
    DateTime dateTime = DateTime.parse(timestampString);

    // Get time ago
    String timeAgo = timeago.format(dateTime, locale: 'en');
    return GestureDetector(
      onTap: () async {
         context.read(Ab).state =true;
// Dispose of the previous controller
 context.read(videoPlayerControllerProvider).state?.dispose();
// Create and initialize the new controller
 final newVideoController =
 VideoPlayerController
 .network(
 "https://vz-37aa8c85-08a.b-cdn.net/$vidioguid/playlist.m3u8",
 );
 await newVideoController
 .initialize().then((value) {
 
                                                                });

                                                            // Update the video player controller provider with the new controller
                                                            context
                                                                    .read(
                                                                        videoPlayerControllerProvider)
                                                                    .state =
                                                                newVideoController;
                                                               context.read(selectedVideoProvider).state = video;

                                                               

                                                            // Seek to the previous position (optional)
                                                          
                                                                    context
                                                                            .read(Ab)
                                                                            .state =
                                                                        false;
       
      },
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hasPadding ? 12.0 : 0,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 220.0,
                      
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://vz-37aa8c85-08a.b-cdn.net/$vidioguid/$videosid",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SizedBox(
                            child: Shimmer.fromColors(
                                baseColor: const Color.fromARGB(255, 65, 65, 65),
                                highlightColor:
                                    const Color.fromARGB(255, 141, 141, 141),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 220.0,
                                  color: Colors.amber,
                                )),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  
                ],
              ),
              Positioned(
                bottom: 8.0,
                right: hasPadding ? 20.0 : 8.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: const Color.fromARGB(160, 0, 0, 0),
                  child: Text(
                    formattedDuration,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Container(
                      alignment: Alignment.topCenter,
                      width: 45,
                      height: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: video.title.split('/')[1] == 'sinhala'
                            ? Image.asset(
                                "assets/logo1.jpg",
                                fit: BoxFit.cover,
                              )
                            : video.title.split('/')[1] == 'tvcaps'
                                ? Image.asset(
                                    "assets/logo2.jpg",
                                    fit: BoxFit.cover,
                                  )
                                : video.title.split('/')[1] == 'animi'
                                    ? Image.asset(
                                        "assets/logo3.jpg",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/logo4.jpg",
                                        fit: BoxFit.cover,
                                      ),
                      )),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(video.title.split('/')[3] =="E"
                                                            ? video.title.split('/')[6]
                                                            : video.title.split('/')[3] =="S"
                                                                ? video.title.split('/')[5]
                                                                : video.title.split('/')[3],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15.0)),
                      ),
                      Flexible(
                        child: Text('$timeAgo • ${video.views} views • ',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 100, 100, 100),
                                fontSize: 14.0)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.more_vert,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

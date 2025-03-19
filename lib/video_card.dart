import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:videoviwerplayer/databasehelper.dart';
import 'package:videoviwerplayer/home.dart';
import 'package:videoviwerplayer/nav_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;


class VideoCard extends StatelessWidget {
  final CustomVideo video;
  final bool hasPadding;
  final VoidCallback? onTap;

  const VideoCard({
    Key? key,
    required this.video,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);

  Future<void> fetchVideosAndUpdateProvider(
      BuildContext context, String colid, int page, String trnding) async {
    var url =
        'https://video.bunnycdn.com/library/339747/videos?page=$page&itemsPerPage=20&collection=$colid&orderBy=title&search=$trnding';
    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };
    print('awawaw');
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> newItem = json.decode(response.body);

        if (newItem.containsKey('items')) {
          context.read(videoListProvider).state = [];
          final List<dynamic> videos = newItem['items'];
          for (var video in videos) {
            String guid = video['guid'];
            int id = video['videoLibraryId'];
            String title = video['title'];
            String tumb = video['thumbnailFileName'];
            String dateTime = video['dateUploaded'];
            int length = video['length'];
            String description = '';
            String playlist = video['collectionId'];
            if (video.containsKey('metaTags') && video['metaTags'].isNotEmpty) {
              description = video['metaTags'][0]['value'];
            }

            context.read(videoListProvider).state.add(CustomVideo(
                  guid: guid,
                  title: title,
                  views: 0,
                  thumb: tumb,
                  dateTime: dateTime,
                  length: length,
                  discription: description,
                  playlist: playlist,
                ));
          }
          context.read(videoListProvider).state = [
            ...context.read(videoListProvider).state
          ];
        } else {
          print('No items found in the response.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

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
    String trnding = '';

    String formattedDuration =
        '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    timeago.setLocaleMessages('en', timeago.EnMessages()); // Set the locale

    String timestampString = video.dateTime.toString();
    DateTime dateTime = DateTime.parse(timestampString);

    // Get time ago
    String timeAgo = timeago.format(dateTime, locale: 'en');
    return GestureDetector(
      onTap: () {
        final db = DatabaseHelper();
        db.insertVideo(video).then((value) {
          print(video.title);
          print("klskllllllllllllllllllllllllllll");
        });
        String videoid = video.guid;
        print('video.guid$videoid gggggggggggggggggggg ggg');
        context.read(boolclos).state = true;
        context.read(videoPlayerControllerProvider).state?.dispose();
        videoController = VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
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
        int O = int.parse(video.title.split('/')[0]);
        int page;
        page = O ~/ 10;

        fetchVideosAndUpdateProvider(
            context,
            video.playlist,
            video.playlist == '' ? 1 : page + 1,
            video.playlist == '' ? 'treandingList' : '');
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
                      width: double.infinity,
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
                        child: Text(video.title.split('/')[3],
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

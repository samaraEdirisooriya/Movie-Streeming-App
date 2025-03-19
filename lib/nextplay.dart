import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie/nav_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'package:video_player/video_player.dart';


class nextplay extends StatelessWidget {
  final int place;
  final bool max;
  final bool hasPadding;
  final VoidCallback? onTap;

  const nextplay({
    Key? key,
    required this.max,
    required this.place,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late VideoPlayerController videoController;
    int epi = 0;
    String videoguid;
    String videosid;
    return Consumer(builder: (context, watch, child) {
      final video = watch(selectedVideoProvider).state;
      final videolist = watch(videoListProvider).state;
      if (video != null) {
        final titleParts = video.title.split('/');
        if (titleParts.length >= 4) {
          final category = titleParts[3];
          if (category == "E" || category == "S") {
            final episode = int.tryParse(titleParts[4]);
            if (episode != null) {
              epi = episode;
              max == true ? epi = epi + place : epi = epi - place;
            }
            print('$epi ssswwwwwwwwwwwwwww');
          }
        }
      }

      final isload = watch(boolclos).state;

      return videolist.length==epi  || epi < 0
          ? Container()
          : Column(
            children: [
              Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(10, 255, 255, 255),
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              // alternatively, do this:
                              // borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Consumer(builder: (context, watch, child) {
                                final videolist2 = watch(videoListProvider).state;
                                if (epi >= 0 && epi < videolist2.length) {
                                    videoguid = videolist2[epi].guid;
                                 videosid = videolist2[epi].thumb;
                                              } else {
  // Handle the case where the index is out of bounds
  // You might want to provide default values or handle this situation differently based on your requirements
                            videoguid = ''; // Default value or handle differently
                                        videosid = ''; // Default value or handle differently
                                          }
                                
                                       
                                return Offstage(
                                  offstage: videolist == null,
                                  child: GestureDetector(
                                    onTap: () async {
                                                        context.read(Ab).state =
                                                                true;

                                                            
                                                      
                                                            // Dispose of the previous controller
                                                             context.read(videoPlayerControllerProvider).state?.dispose();

                                                            // Create and initialize the new controller
                                                            final newVideoController =
                                                                VideoPlayerController
                                                                    .network(
                                                              "https://vz-37aa8c85-08a.b-cdn.net/$videoguid/playlist.m3u8",
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
                                                               context.read(selectedVideoProvider).state = videolist[epi];

                                                               

                                                            // Seek to the previous position (optional)
                                                          
                                                                    context
                                                                            .read(Ab)
                                                                            .state =
                                                                        false;},
                                                       
                                                          
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10)),
                                            // alternatively, do this:
                                            // borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            epi >= 0 && epi < videolist2.length
      ? 
                                                "https://vz-37aa8c85-08a.b-cdn.net/$videoguid/$videosid": "https://cdn3.iconfinder.com/data/icons/wifi-2/460/connection-error-512.png",
                                            imageBuilder: (context, imageProvider) =>
                                                Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => SizedBox(
                                              child: Shimmer.fromColors(
                                                  baseColor: const Color.fromARGB(
                                                      255, 65, 65, 65),
                                                  highlightColor:
                                                      const Color.fromARGB(
                                                          255, 141, 141, 141),
                                                  child: Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        20,
                                                    height: 220.0,
                                                    color: Colors.amber,
                                                  )),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                const Icon(Icons.error),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if (epi < videolist.length)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 8.0, bottom: 5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        place == 0
                                                            ? 'Cuming Up Next '
                                                            : 'Previus',
                                                        textAlign: TextAlign.start,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12.0,
                                                          color: Color.fromARGB(
                                                              195, 255, 123, 0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        videolist2[epi]
                                                                    .title
                                                                    .split('/')[3] ==
                                                                "E"
                                                            ? 'Episode ${videolist2[epi]
                                                                    .title
                                                                    .split('/')[4]}'
                                                            : video!.title.split(
                                                                        '/')[3] ==
                                                                    "S"
                                                                ? 'Part ${videolist2[epi]
                                                                        .title
                                                                        .split('/')[4]}'
                                                                : '',
                                                        textAlign: TextAlign.start,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12.0,
                                                          color: Color.fromARGB(
                                                              255, 255, 255, 255),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Title not available',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    color: Color.fromARGB(
                                                        255, 80, 80, 80),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      150,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 8.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    videolist2.length > epi && epi!=1
                                                        ? videolist2[epi]
                                                                    .title
                                                                    .split('/')[3] ==
                                                                "E"
                                                            ? videolist2[epi]
                                                                .title
                                                                .split('/')[6]
                                                            : videolist2[epi]
                                                                        .title
                                                                        .split(
                                                                            '/')[3] ==
                                                                    "S"
                                                                ? videolist2[epi]
                                                                    .title
                                                                    .split('/')[5]
                                                                : videolist2[epi]
                                                                    .title
                                                                    .split('/')[3]
                                                        :videolist2.length >epi? videolist2[epi]
                                                                .title
                                                                .split('/')[6] :"no data",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17.0,
                                                      color: Color.fromARGB(
                                                        255,
                                                        255,
                                                        255,
                                                        255,
                                                      ),
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                videolist2.length > epi && epi!=1
                                                    ? videolist2[epi]
                                                        .title
                                                        .split('/')[2]
                                                    : videolist2.length > epi? "last epi":"no data",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0,
                                                  color: Color.fromARGB(
                                                      181, 129, 129, 129),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                  splashRadius: 20,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                    )
                  ],
                ),
            ],
          );
    });
  }
}

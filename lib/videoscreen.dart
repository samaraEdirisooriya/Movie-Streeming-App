import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:videoviwerplayer/constants.dart';
import 'package:videoviwerplayer/customvideoconttroller.dart';
import 'package:videoviwerplayer/dbhelper2.dart';
import 'package:videoviwerplayer/home.dart';
import 'package:videoviwerplayer/nav_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'package:videoviwerplayer/nextplay.dart';
import 'package:videoviwerplayer/playlist.dart';
import 'package:videoviwerplayer/video_card.dart';

final controller = ScrollController();

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? videoController;
  VideoPlayerController? _newVideoPlayerController;
  MiniplayerController? min;
  List<String> qualityOptions = ['High Quality (240p)', 'Medium', 'Low'];
  String selectedQuality = 'High Quality (240p)';
  bool isex = false;
  bool isloding = false;
  int page = 1;
  bool l1 = false;
  bool l2 = false;
  int epi = 0;
  String quary2 = '';
  bool endoflist = false;
  String timeAgo =
      timeago.format(DateTime(2017, 2, 1, 2, 2, 2, 2), locale: 'en');
  late Duration videoposition;

  @override
  void initState() {
    print("saaaaaaaaaaaaaaaa");
    l1 = true;
    l2 = true; // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      body: Consumer(
        builder: (context, watch, child) {
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
                }
              }
            }
          }
           final abs = watch(Ab).state;
          final isload = watch(boolclos).state;
          videoController = watch(videoPlayerControllerProvider).state;
          final miniplayercontroller =
              watch(miniPlayerControllerProvider).state;

          if (videoController?.value.isInitialized != true) {
            final videolist = watch(videoListProvider).state;
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          print(videolist.length);
          print(isload);
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 255,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.black,
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: Chewie(
                                controller: ChewieController(
                                  draggableProgressBar: true,
                                  progressIndicatorDelay: const Duration(microseconds: 20),
                                
                                  materialProgressColors: ChewieProgressColors(
                                    playedColor: Colors.red,
                                    handleColor: Colors.white,
                                    bufferedColor: const Color.fromARGB(125, 255, 193, 7),
                                    backgroundColor: Colors.grey
                                  ),
                                  videoPlayerController: videoController!,
                                  autoPlay: false,
                                  looping: false,
                                  optionsTranslation: OptionsTranslation(),
                                  additionalOptions: (context) {
                                    return <OptionItem>[
                                      OptionItem(
                                        onTap: () {},
                                        iconData: Icons.abc,
                                        title: 'option 1',
                                      )
                                    ];
                                  },
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 245,
                                ),
                                progressbars(
                                  videoController: videoController!,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 250,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.all(0),
                          itemCount:
                              videolist.length + 2, // +1 for playlist section
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Render the playlist section
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                       
                                          video != null
                                              ? video.title.split('/')[3] ==
                                                      "E"
                                                  ? Text("Episode ${video.title
                                                          .split('/')[4]} Seson ${video.title.split('/')[5]}",
                                                 style: const TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                172, 255, 223, 186),
                                          ), ): video.title
                                                              .split('/')[3] ==
                                                          "S"
                                                      ? Text("Part${video.title
                                                              .split('/')[4]}",
                                                     style: const TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                172, 255, 223, 186),
                                          ), ): Container()
                                              :const Text( 'No video selected',),
                                          
                                        
                                        Text(
                                          video != null
                                              ? video.title.split('/')[3] ==
                                                      "E"
                                                  ? video.title.split('/')[6]
                                                  : video.title
                                                              .split('/')[3] ==
                                                          "S"
                                                      ? video.title
                                                          .split('/')[5]
                                                      : video.title
                                                          .split('/')[3]
                                              : 'No video selected',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      '$timeAgo • ',
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                            255, 100, 100, 100),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedQuality,
                                            underline: Container(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedQuality = newValue!;
                                              });
                                            },
                                            items: qualityOptions.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.download,
                                            color: Colors.white),
                                      ),
                                      IconButton(

                                        onPressed: () async {
                                          final videoo= watch(selectedVideoProvider).state;
                                          final id = await DatabaseHelper2().getVideoById(videoo!.guid);
if (id != null) {
   print('Video found.');
}

 else {
   
   final db = DatabaseHelper2();
        db.insertVideo(videoo).then((value) {
          print(video?.title);
          print("klskllllllllllllllllllllllllllll");
        });
 }
 
  
                                          
                                           
                                        },
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.share,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0 ,left: 5.0, right: 8.0),
                                    child: ExpansionTile(
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          isex = value;
                                        });
                                      },
                                      collapsedIconColor: Colors.white,
                                      iconColor: Colors.white,
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Description',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Container(
                                                width: 50,
                                                height: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.orange),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Text(
                                                  "Action",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text(
                                            video != null
                                                ? video.discription
                                                : 'No video selected',
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              
                                              fontSize: 16.0,
                                              color: Color.fromARGB(
                                                  255, 100, 100, 100),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  video!.playlist!=""?
                                  const Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: nextplay(
                                      place: 0,
                                      max: false,
                                    ),
                                  ):Container(),
                                  video.playlist!=""?
                                  const Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: nextplay(
                                      place: 2,
                                      max: false,
                                    ),
                                  ):Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13.0, right: 13.0, top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Play List',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                       video.playlist!=""? InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: () {
                                            context.read(currentIndexProvider).state = 3;
                                            context
            .read(miniPlayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MIN);

                                            print(videolist.length);
                                            
                                          },

                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'See All',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Color.fromARGB(
                                                    255, 49, 155, 255),
                                              ),
                                            ),
                                          ),
                                        ):Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // Render video cards
                              final videoIndex =
                                  index - 1; // Adjust index for videoList
                              if (videoIndex < videolist.length) {
                                final video = videolist[videoIndex];
                                return PlaylistCard(video: video);
                              } else {
                                return const Text("No more data");

                                // Check if we need to display "No more data"
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              abs==true?
              Center(
                  child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(179, 66, 66, 66),
                ),
                child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
              )):Container(),
            ],
          );
        },
      ),
    );
  }
}

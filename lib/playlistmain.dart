import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movie/home.dart';
import 'package:movie/nav_screen.dart';
import 'package:movie/video_card.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class Mainplaylist extends StatefulWidget {
  const Mainplaylist({super.key});

  @override
  State<Mainplaylist> createState() => _MainplaylistState();
}

class _MainplaylistState extends State<Mainplaylist>
    with TickerProviderStateMixin {
  List<playlist> videoList = [];
  List<CustomVideo> videoplaylist = [];
  bool isLoading = false;
  bool endOfList = false;
  int page = 1;
  final int limit = 20;
  final controller = ScrollController();
  final bool _isControllerInitialized = false;
 
  String name = '';
  int currentPage = 1;
  late VideoPlayerController videoController;
  String colid = '';
  int initval = 0;
  int _currentIndex = 0;
  late TabController _tabController;
  bool isLoading1 = false;
  bool xd = false;

  @override
  void initState() {
    super.initState();
    final video = context.read(selectedVideoProvider).state;
    setState(() {});
    String index = video!.title.split('/')[3] == "E"
        ? video.title.split('/')[7]
        : video.title.split('/')[3] == "S"
            ? video.title.split('/')[6]
            : '';
    xd = true;
    colid = video.playlist;
    fetchTabs(index);
    videolist();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset &&
          !isLoading &&
          !endOfList) {
        videolist();
      }
    });
  }

  Future<void> videolist() async {
    if (isLoading || endOfList) {}
    setState(() {
      isLoading = true;
    });
    const limit = 25;
    var url =
        'https://video.bunnycdn.com/library/339747/videos?page=$page&itemsPerPage=10&collection=$colid&orderBy=date';

    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> newItem = json.decode(response.body);

      setState(() {
        page++;
        // Corrected variable name
        if (newItem['items'].length < limit) {
          // Changed to use 'items' key
          endOfList = true; // Corrected variable name
        }
      });

      if (newItem.containsKey('items')) {
        List<dynamic> videos =
            newItem['items']; // Initialize list to hold CustomVideo objects
        for (var video in videos) {
          String guid = video['guid'];
          int id = video['videoLibraryId'];
          String title = video['title'];
          String thumb = video['thumbnailFileName']; // Corrected variable name
          String dateTime = video['dateUploaded'];
          int length = video['length'];
          String description = '';
          String playlist = video['collectionId'];
          if (video.containsKey('metaTags') && video['metaTags'].isNotEmpty) {
            description = video['metaTags'][0]['value'];
          }

          videoplaylist.add(CustomVideo(
            // Add CustomVideo object to the list
            guid: guid,
            title: title,
            views: 0,
            thumb: thumb,
            dateTime: dateTime,
            length: length,
            discription: description, // Corrected variable name
            playlist: playlist,
          ));
        }
        print("safffffff");
        print(videoplaylist.length);
        setState(() {
          isLoading = false;
        }); // Return the list of CustomVideo objects
      } else {
        print('No items found in the response.');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> fetchTabs(String index) async {
    if (isLoading || endOfList) {}
    setState(() {
      isLoading1 = true;
    });
    var url =
        'https://video.bunnycdn.com/library/339747/collections?page=1&itemsPerPage=$limit&orderBy=name&search=$index';

    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> newItem = json.decode(response.body);
      if (newItem.containsKey('items')) {
        List<dynamic> plays = newItem['items'];
        for (var play in plays) {
          String guid = play['guid'];
          String title = play['name'];
          int views = play['videoCount'];
          setState(() {
            videoList.add(playlist(guid: guid, name: title, videoCount: views));
          });
        }

        setState(() {
          isLoading1 = false;
        });
        if (xd == true) {
          final video = context.read(selectedVideoProvider).state;
          setState(() {
            _currentIndex =
                videoList.length - int.parse(video!.title.split('/')[5]);
          });

          xd = false;
          print(_currentIndex);
        }
      } else {
        print('No items found in the response.');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 20, 20, 20),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              color: const Color.fromARGB(228, 20, 20, 20),
              child: isLoading1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(20, 158, 158, 158),
                          highlightColor:
                              const Color.fromARGB(125, 158, 158, 158),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.amber,
                            ),
                          )),
                    )
                  : Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(
                            'Seson ${videoList[_currentIndex].name.split('/')[0]}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: videoList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 10.0, bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      endOfList = false;
                                      page = 1;
                                      videoplaylist = [];
                                      _currentIndex = index;
                                      colid = videoList[index].guid;
                                      videolist();
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: _currentIndex == index
                                            ? const Color.fromARGB(185, 255, 182, 25)
                                            : const Color.fromARGB(
                                                136, 255, 255, 255),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Center(
                                        child: Text(
                                      "S${videoList[index].name.split('/')[0]}",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: _currentIndex == index
                                              ? Colors.white
                                              : Colors.black),
                                    )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
                padding: const EdgeInsets.only(top:8.0,left: 25.0,bottom: 15.0),
                alignment: Alignment.centerLeft,
                child:isLoading1?Container(): Column(
                  children: [
                    Text(
              videoList[_currentIndex].name.split('/')[1],
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(153, 255, 255, 255)),
                    ),
                    Text(
                      "Episode Count ${videoList[_currentIndex].videoCount}",
                      style: const TextStyle(
                          fontSize: 13.0,
                          color: Color.fromARGB(134, 255, 136, 24)),
                    ),
                  ],
                )),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: controller,
                      itemCount: videoplaylist.length,
                      itemBuilder: (context, index) {
                        if (index < videoplaylist.length) {
                          return VideoCard(video: videoplaylist[index]);
                        } else {
                          return endOfList
                              ? Center(child: Container(
                                height: 200,
                                color: Colors.red,
                              ))
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

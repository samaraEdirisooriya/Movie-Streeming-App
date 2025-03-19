import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/video_card.dart';
import 'package:sqflite/sqflite.dart';


class Home extends StatefulWidget { 
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CustomVideo> videoList = [];
  final controller = ScrollController();
  int page = 1;
  bool isLoading = false;
  bool endOfList = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset &&
          !isLoading &&
          !endOfList) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetchData() async {
    if (isLoading || endOfList) return;
    const limit = 10;
    setState(() {
      isLoading = true;
    });

    var url =
        'https://video.bunnycdn.com/library/339747/videos?page=$page&itemsPerPage=$limit&orderBy=views';
    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> newItem = json.decode(response.body);
      if (!mounted) return;

      if (newItem.containsKey('items')) {
        List<dynamic> videos = newItem['items'];
        if (videos.isEmpty || videos.length < limit) {
          setState(() {
            endOfList = true;
            print('End of list');
          });
        }
        for (var video in videos) {
          String guid = video['guid'];
          String title = video['title'];
          String thumb = video['thumbnailFileName'];
          String dateTime = video['dateUploaded'];
          int views = video['views'];
          int length = video['length'];
          String playlist = video['collectionId'];
          String description = '';
          if (video.containsKey('metaTags') && video['metaTags'].isNotEmpty) {
            description = video['metaTags'][0]['value'];
          }

          videoList.add(CustomVideo(
            guid: guid,
            title: title,
            views: views,
            thumb: thumb,
            dateTime: dateTime,
            length: length,
            discription: description,
            playlist: playlist,
          ));
        }
        setState(() {
          page++;
        });
      } else {
        print('No items found in the response.');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      endOfList = false;
      page = 1;
      videoList.clear();
    });
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        color: Colors.amber,
        backgroundColor: Colors.black,
        onRefresh: refresh,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: videoList.length +1,
                itemBuilder: (context, index) {
                  if (index < videoList.length) {
                    final video = videoList[index];
                    return VideoCard(video: video);
                  } else {
                    return endOfList?Container(
                    height: 300,
                    width: 100,
                    color: Colors.red,
                  ):isLoading?Container(
                    height: 100,
                    alignment: Alignment.topCenter,
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                      ):Container();
                  }
// Loading indicator when end of list is reached
                },
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}

class CustomVideo {
  final String guid;
  final String title;
  final int views;
  final String thumb;
  final String dateTime;
  final int length;
  final String discription;
  final String playlist;

  // Add other parameters here...

  CustomVideo(
      {required this.guid,
      required this.title,
      required this.views,
      required this.thumb,
      required this.dateTime,
      required this.length,
      required this.discription,
      required this.playlist
      // Add other parameters here...
      });

 Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'title': title,
      'views': views,
      'thumb': thumb,
      'dateTime': dateTime,
      'length': length,
      'discription': discription,
      'playlist': playlist,
    };
  }

  static Future<void> insertVideo(CustomVideo video, Database db) async {
    await db.insert(
      'videos',
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}


class playlist {
  final String guid;
  final String name;
  final int videoCount;

  // Add other parameters here...

  playlist({
    required this.guid,
    required this.name,
    required this.videoCount,
    // Add other parameters here...
  });
}

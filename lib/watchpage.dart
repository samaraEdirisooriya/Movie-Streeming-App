import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/constants.dart';
import 'package:movie/databasehelper.dart';
import 'package:movie/dbhelper2.dart';
import 'package:movie/home.dart';
import 'package:movie/video_card.dart';
import 'package:shimmer/shimmer.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<CustomVideo>> _videos;
    late Future<List<CustomVideo>> _videos2;

  @override
  void initState() {
    super.initState();
    _videos = _fetchVideos(1);
     _videos2 =DatabaseHelper2().getVideos();
  }

  Future<void> _refresh() async {
    setState(() {
      _videos = _fetchVideos(1);
      _videos2 =DatabaseHelper2().getVideos();
    });
  }

  Future<List<CustomVideo>> _fetchVideos(int page) async {
    final videos = await DatabaseHelper().getVideos(page, 20);
    return videos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.kBlackColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 32, 20, 3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            right: -88,
            child: Container(
              height: 166,
              width: 166,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.kYellowColor.withOpacity(0.5),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
                child: Container(
                  height: 166,
                  width: 166,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.kCyanColor.withOpacity(0.5),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 200,
                  sigmaY: 200,
                ),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              edgeOffset: 70,
              onRefresh: _refresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                       Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(top: 25.0,left: 30),
                             child: Text(
                                  "Library Hub",
                                  textAlign: TextAlign.start,
                                  
                                  style:GoogleFonts.lato(
    textStyle: Theme.of(context).textTheme.displayLarge,
    fontSize: 25,
    color: const Color.fromARGB(206, 255, 255, 255),
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  ),
                                ),
                           ),
                         ],
                       ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                             
                                Container(
                                  height: 80,
                                  padding: const EdgeInsets.only(left: 13),
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Text(
                                        "History",
                                        style: GoogleFonts.lato(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 16,
                                color: const Color.fromARGB(206, 255, 255, 255),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                          )
                                      ),
                                      
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: GestureDetector(
                                    onTap: () {
                                    DatabaseHelper().clearVideos();
                                    },
                                    child: const Text(
                                      "See All",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 210,
                          alignment: Alignment.topLeft,
                          child: FutureBuilder<List<CustomVideo>>(
                            future: _videos,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < snapshot.data!.length) {
                                      final video = snapshot.data![index];
                                      final videoGuid = video.guid;
                                      final videoSid = video.thumb;
                                      return Column(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: 120,
                                            padding: const EdgeInsets.only(left: 10),
                                            
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: "https://vz-37aa8c85-08a.b-cdn.net/$videoGuid/$videoSid",
                                                  imageBuilder: (context, imageProvider) =>
                                                      Container(
                                                    height: 150,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                     
                                                     
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) => Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Shimmer.fromColors(
                                                      baseColor: const Color.fromARGB(255, 65, 65, 65),
                                                      highlightColor: const Color.fromARGB(255, 141, 141, 141),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width - 20,
                                                        height: 220.0,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.amber,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                                Container(
                                                  height: 150,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [Colors.transparent, Color.fromARGB(169, 0, 0, 0)],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                width: 100,
                                                child: Text(
                                                  video.title.split('/')[3] == "E"
                                                      ? video.title.split('/')[6]
                                                      : video.title.split('/')[3] == "S"
                                                          ? video.title.split('/')[5]
                                                          : video.title.split('/')[3],
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(255, 214, 214, 214),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.more_vert_sharp,color: Colors.white,)
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container(
                                        padding: const EdgeInsets.only(left: 10, top: 60),
                                        alignment: Alignment.topCenter,
                                        height: 50,
                                        width: 100,
                                        child: snapshot.data!.length>5?const Row(
                                          children: [
                                            Text(
                                              "See All",
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ):Container(),
                                      );
                                    }
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                padding: const EdgeInsets.only(left: 13),
                                width: 200,
                                alignment: Alignment.center,
                                child: Text(
                                        "Libeary",
                                        style: GoogleFonts.lato(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 16,
                                color: const Color.fromARGB(206, 255, 255, 255),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                          )
                                      ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 13),
                                child: Text(
                                  "See All",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height- 215,
                          alignment: Alignment.topLeft,
                          child:FutureBuilder<List<CustomVideo>>(
        future: _videos2,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final video = snapshot.data![index];
                return VideoCard(video: video);
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
                        ),
                    )],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

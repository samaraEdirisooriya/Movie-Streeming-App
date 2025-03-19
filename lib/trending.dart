import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:videoviwerplayer/constants.dart';
import 'package:videoviwerplayer/home.dart';
import 'package:videoviwerplayer/video_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int itemsPerPage = 5; // Number of items to load per page

  final ScrollController _scrollController = ScrollController();
  final controller = ScrollController();
  bool isLoading = false;
  List<CustomVideo> videoList = [];
  List<CustomVideo> videoList2 = [];
  bool endoflist = false;
  bool isloding = false;
  String quary2 = '';
  int page = 1;
  bool status = false;
  @override
  void initState() {
    
    fetchData();
    slider();

    print(videoList2);
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchData();

        print('donee');
      }
    });
    super.initState();
  }

  Future<void> fetchData() async {
    if (isloding) return;
    const limit = 25;

    var url =
        'https://video.bunnycdn.com/library/339747/videos?page=$page&itemsPerPage=$limit&orderBy=date&search=treandingList';

    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };

    if (!mounted) return;

    var response = await http.get(Uri.parse(url), headers: headers);
    if (!mounted) return;

    if (response.statusCode == 200) {
      Map<String, dynamic> newItem = json.decode(response.body);

      setState(() {
        page++;
        isloding = false;
        if (newItem.length < limit) {
          endoflist = true;
        }
      });
      if (newItem.containsKey('items')) {
        List<dynamic> videos = newItem['items']; // Accessing the 'items' array
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

          setState(() {
            videoList.add(CustomVideo(
                guid: guid,
                title: title,
                views: 0,
                thumb: tumb,
                dateTime: dateTime,
                length: length,
                discription:
                    description,
                    playlist: playlist)); // Here, 'views' is an example, modify as needed
          });

          // Add the 'guid' to the 'items' list
        }
      } else {
        print('No items found in the response.');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> slider() async {
    if (isloding) return;
    const limit = 25;

    var url =
        'https://video.bunnycdn.com/library/339747/videos?page=$page&itemsPerPage=$limit&orderBy=date&search=$quary2';

    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };

    if (!mounted) return;

    var response = await http.get(Uri.parse(url), headers: headers);
    if (!mounted) return;

    if (response.statusCode == 200) {
      Map<String, dynamic> newItem = json.decode(response.body);

      setState(() {
        page++;
        isloding = false;
        if (newItem.length < limit) {
          endoflist = true;
        }
      });
      if (newItem.containsKey('items')) {
        List<dynamic> videos1 = newItem['items']; // Accessing the 'items' array
        for (var videoq in videos1) {
          String guid = videoq['guid'];
          int id = videoq['videoLibraryId'];
          String title = videoq['title'];
          String tumb = videoq['thumbnailFileName'];
          String dateTime = videoq['dateUploaded'];
          int length = videoq['length'];
          String description = '';
          String playlist = videoq['collectionId'];
          if (videoq.containsKey('metaTags') && videoq['metaTags'].isNotEmpty) {
            description = videoq['metaTags'][0]['value'];
          }

          setState(() {
            videoList2.add(CustomVideo(
                guid: guid,
                title: title,
                views: 0,
                thumb: tumb,
                dateTime: dateTime,
                length: length,
                discription: description,
                playlist:
                    playlist)); // Here, 'views' is an example, modify as needed
          });
          status = true;

          // Add the 'guid' to the 'items' list
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.kBlackColor,
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                height: 200,
                width: 200,
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
                    height: 200,
                    width: 200,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
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
              bottom: -100,
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
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    expandedHeight: 150,
                    floating: false,
                    pinned: false,
                    leading: IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.menu),
                    ),
                    backgroundColor: const Color.fromARGB(174, 44, 44, 44),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Hi,",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "See whats new today",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(125, 255, 255, 255)),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(120, 151, 151, 151),
                                highlightColor:
                                    const Color.fromARGB(150, 254, 83, 186),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Sinhala MovieCaps',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Icon(Icons.movie_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            status
                                ? CarouselSlider(
                                    items: videoList2
                                        .map(
                                          (url) => CachedNetworkImage(
                                            imageUrl:
                                                "https://vz-37aa8c85-08a.b-cdn.net${url.guid}/${url.thumb}",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                    baseColor:
                                                        const Color.fromARGB(
                                                            20, 158, 158, 158),
                                                    highlightColor:
                                                        const Color.fromARGB(
                                                            125, 158, 158, 158),
                                                    child: Container(
                                                      color: Colors.amber,
                                                      width: 300,
                                                      height: 180,
                                                    )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        )
                                        .toList(),
                                    options: CarouselOptions(
                                      height: 190,

                                      pauseAutoPlayOnTouch: true,
                                      autoPlay: true, // Enable auto-play
                                      autoPlayInterval: const Duration(
                                          seconds:
                                              5), // Set the auto-play duration
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 1000),
                                      pauseAutoPlayInFiniteScroll:
                                          true, // Animation duration
                                      autoPlayCurve: Curves
                                          .fastOutSlowIn, // Animation curve
                                      enableInfiniteScroll:
                                          true, // Loop through the images infinitely
                                      enlargeCenterPage:
                                          true, // Make the center image larger
                                      aspectRatio:
                                          16 / 9, // Set the aspect ratio
                                      viewportFraction:
                                          0.75, // Set the fraction of the viewport for each image
                                      scrollDirection:
                                          Axis.horizontal, // Scroll direction
                                      onPageChanged: (index, reason) {
                                        // Callback when the page changes
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(
                                            20, 158, 158, 158),
                                        highlightColor: const Color.fromARGB(
                                            125, 158, 158, 158),
                                        child: Container(
                                          color: Colors.amber,
                                          width: 300,
                                          height: 180,
                                        )),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Whats Trending",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ])),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index < videoList.length) {
                          final video = videoList[index];

                          return Column(
                            children: [
                              Stack(
                                children: [
                                  VideoCard(video: video),
                                  Positioned(
                                    top: 25,
                                    left: 20,
                                    child: Container(
                                      width: 160,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            stops: [
                                              0.1,
                                              0.4,
                                            ],
                                            colors: [
                                              Color.fromARGB(198, 181, 91, 63),
                                              Color.fromARGB(198, 150, 122, 0),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          '# Treanding 0${index + 1}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return endoflist
                              ? const Center(child: Text("No more data"))
                              : Center(
                                  child: Column(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: const Color.fromARGB(
                                              255, 65, 65, 65),
                                          highlightColor: const Color.fromARGB(
                                              160, 141, 141, 141),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            height: 100,
                                            color: const Color.fromARGB(
                                                160, 255, 193, 7),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Shimmer.fromColors(
                                                baseColor: const Color.fromARGB(
                                                    176, 65, 65, 65),
                                                highlightColor: const Color.fromARGB(
                                                    139, 141, 141, 141),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        158, 255, 193, 7),
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: SizedBox(
                                                child: Shimmer.fromColors(
                                                    baseColor: const Color.fromARGB(
                                                        176, 65, 65, 65),
                                                    highlightColor:
                                                        const Color.fromARGB(
                                                            139, 141, 141, 141),
                                                    child: Container(
                                                      width: 200,
                                                      height: 32,
                                                      color: const Color.fromARGB(
                                                          155, 255, 193, 7),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 65, 65, 65),
                                            highlightColor: const Color.fromARGB(
                                                160, 141, 141, 141),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                              height: 100,
                                              color: const Color.fromARGB(
                                                  136, 255, 193, 7),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Shimmer.fromColors(
                                                baseColor: const Color.fromARGB(
                                                    176, 65, 65, 65),
                                                highlightColor: const Color.fromARGB(
                                                    139, 141, 141, 141),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        123, 255, 193, 7),
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Shimmer.fromColors(
                                                  baseColor: const Color.fromARGB(
                                                      176, 65, 65, 65),
                                                  highlightColor:
                                                      const Color.fromARGB(
                                                          139, 141, 141, 141),
                                                  child: Container(
                                                    width: 200,
                                                    height: 32,
                                                    color: const Color.fromARGB(
                                                        110, 255, 193, 7),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        }
                      },
                      childCount: videoList.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true, // Extend the body behind the app bar
    );
  }
}

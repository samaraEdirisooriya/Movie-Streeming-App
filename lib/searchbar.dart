import 'dart:convert';

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:miniplayer/miniplayer.dart';
import 'package:movie/constants.dart';
import 'package:movie/home.dart';
import 'package:movie/nav_screen.dart';
import 'package:movie/video_card.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

import 'package:shimmer/shimmer.dart';


class serchscreen extends StatefulWidget {
  const serchscreen({super.key});

  @override
  State<serchscreen> createState() => _serchscreenState();
}

class _serchscreenState extends State<serchscreen> {
  int _selectedIndex = 0;

  List<String> tabTitles = [
    'ALL',
    'Sinhala Move Caps',
    'Tab 3',
    'Tab 4',
    'Tab 5'
  ];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<CustomVideo> videoList = [];
  List<CustomVideo> SearchList = [];
  String qury = '';
  String quary2 = '';
  String quary3 = '';
  String select = "";
  bool filt = true;
  final controller = ScrollController();
  bool isfilter = false;
  int countfilter = 0;
  List<String> items = [];
  int page = 1;
  bool endoflist = false;
  bool isloding = false;
  bool whenserchgo = false;
  bool x = true;
  double widthserch = 0;
  int selectedOption = 0;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    fetchData();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchData();
        print('donee');
      }
    });
    super.initState();
  }

  void clearList() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _searchResults = [];
  late VideoPlayerController videoController;
  bool _isLoading = false;

  Future<void> _search(String quary3) async {
    setState(() {
      _isLoading = true;
      print(quary3);
      SearchList = [];
    });
    final String apiUrl =
        'https://video.bunnycdn.com/library/339747/videos?page=1&itemsPerPage=30&orderBy=date&search=$quary3';
    // replace with your actual API endpoint
    var headers = {
      'AccessKey': 'e78a5d05-9efa-4dc5-aa16e96b2ddb-96ac-4030',
      'accept': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          _searchResults = List.from(data['items']);
        });

        if (data.containsKey('items')) {
          List<dynamic> videossarch = data['items'];
          SearchList = []; // Accessing the 'items' array
          for (var video1 in videossarch) {
            String guid = video1['guid'];
            int id = video1['videoLibraryId'];
            String title = video1['title'];
            String tumb = video1['thumbnailFileName'];
            String dateTime = video1['dateUploaded'];
            int length = video1['length'];
            String description = '';
            String playlist = video1['collectionId'];
            if (video1.containsKey('metaTags') &&
                video1['metaTags'].isNotEmpty) {
              description = video1['metaTags'][0]['value'];
            }

            setState(() {
              SearchList.add(CustomVideo(
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

            // Add the 'guid' to the 'items' list
          }
        } else {
          print('No items found in the response.');
        }
      } else {
        // Handle error
        print('Failed to load data. Error ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      setState(() {
        print(SearchList);
        _isLoading = false;
      });
    }
  }

  void fetchData() async {
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
                discription: description,
                playlist:
                    playlist)); // Here, 'views' is an example, modify as needed
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

  Future refresh() async {
    setState(() {
      isloding = false;
      endoflist = false;
      page = 0;
      videoList.clear();
      SearchList.clear();
      quary2 = select + qury;
      print(quary2);
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.kBlackColor,
        body: Stack(children: [
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
              color: Colors.amber,
              backgroundColor: Colors.black,
              onRefresh: refresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                      elevation: 0,
                      expandedHeight: 70,
                      floating: true,
                      pinned: false,
                      snap: true,
                      leadingWidth: MediaQuery.of(context).size.width - 0,
                      leading: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 10),
                          child: Row(children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                setState(() {
                                  isfilter = true;
                                });
                                _showBottomSheet(context);
                              },
                              splashColor: const Color.fromARGB(162, 143, 143, 143),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isfilter
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                151, 255, 255, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.filter_list),
                                    ),
                                    isfilter
                                        ? Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 0, 0),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child:
                                                  Text(countfilter.toString()),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                AnimatedContainer(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  duration: const Duration(microseconds: 300),
                                  width: widthserch,
                                  child: TextField(
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (value) {
                                      qury = _searchController.text;
                                      refresh();
                                      setState(() {
                                        whenserchgo = true;
                                      });
                                    },
                                    focusNode: _focusNode,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                        hintText: "Discover Movies...",
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                    cursorColor: Colors.black,
                                    onChanged: (value) {
                                      setState(() {
                                        SearchList = [];
                                      });

                                      _searchDelayed(_searchController.text);
                                      print('serch$SearchList');
                                    },
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: widthserch == 0
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50))),
                                  child: _isLoading
                                      ? Container(
                                          padding: const EdgeInsets.all(12),
                                          width: 40,
                                          height: 40,
                                          child: const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ))
                                      : IconButton(
                                          color: widthserch == 0
                                              ? const Color.fromARGB(
                                                  255, 0, 0, 0)
                                              : Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              if (widthserch != 0) {
                                                widthserch = 0;
                                                context.read(boolclos).state =
                                                    true;
                                                _searchResults = [];
                                                if (whenserchgo == true) {
                                                  setState(() {
                                                    _selectedIndex = 0;
                                                    selectedOption = 0;
                                                    qury = '';
                                                    whenserchgo = false;
                                                  });

                                                  refresh();
                                                }
                                              } else {
                                                widthserch =
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        180;
                                                FocusScope.of(context)
                                                    .requestFocus(_focusNode);
                                              }
                                            });
                                          },
                                          icon: widthserch == 0
                                              ? const Icon(Icons.search)
                                              : const Icon(Icons.close_outlined)),
                                )
                              ],
                            ),
                          ])),
                      actions: [
                        selectedOption != 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 25),
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        "assets/logo$selectedOption.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              )
                            : Container()
                      ],
                      backgroundColor: const Color.fromARGB(174, 44, 44, 44)),

                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: whenserchgo
                                ? Text("Search Result '$qury'",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ))
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "EXPLOR",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Whats New today",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 100, 100, 100),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 55,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tabTitles.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                    selectedOption = index;

                                    if (index == 0) {
                                      qury = '';
                                      refresh();
                                    }
                                    if (index == 1) {
                                      qury = 'sinhala ';
                                      refresh();
                                    }
                                    if (index == 2) {
                                      qury = 'animi';
                                      refresh();
                                    }
                                    if (index == 3) {
                                      qury = 'animi';
                                      refresh();
                                    }
                                    if (index == 4) {
                                      qury = 'animi';
                                      refresh();
                                    }
                                  });
                                  // Add your logic or function call here when a tab is selected
                                  // For example: _handleTabSelection(index);
                                },
                                child: Container(
                                  width: index == 0
                                      ? 60
                                      : index == 1
                                          ? 140
                                          : 100,
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        _selectedIndex == index
                                            ? const Color.fromARGB(
                                                    172, 254, 83, 186)
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                        _selectedIndex == index
                                            ? const Color.fromARGB(
                                                    172, 9, 251, 211)
                                                .withOpacity(0.2)
                                            : Colors.transparent
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    width: 129,
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _selectedIndex == index
                                              ? Constants.kPinkColor
                                              : const Color.fromARGB(
                                                  106, 255, 255, 255),
                                          _selectedIndex == index
                                              ? const Color.fromARGB(255, 199, 251, 9)
                                              : const Color.fromARGB(
                                                  106, 255, 255, 255),
                                        ],
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _selectedIndex == index
                                            ? const Color.fromARGB(211, 64, 76, 87)
                                            : const Color.fromARGB(255, 64, 76, 87),
                                      ),
                                      child: Center(
                                        child: Text(
                                          tabTitles[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    85, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index < videoList.length) {
                          final video = videoList[index];

                          return Column(
                            children: [
                              VideoCard(video: video),
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
                  // Add more slivers as needed
                ],
              ),
            ),
          ),
          widthserch != 0
              ? Consumer(
                  builder: (context, watch, child) {
                    bool x = watch(boolclos).state;
                    return Positioned(
                      top: 100,
                      child: Container(
                        height: SearchList.length * 50 <=
                                MediaQuery.of(context).size.height - 50
                            ? SearchList.length * 40
                            : MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromARGB(223, 255, 255, 255),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 20, right: 20),
                          itemCount: SearchList.length,
                          itemBuilder: (context, index) {
                            if (index < SearchList.length) {
                              final video1 = SearchList[index];
                              String guid = video1.guid;
                              String tumbname = video1.thumb;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.clear();
                                    SearchList = [];
                                  });

                                  String videoid = video1.guid;

                                  context.read(boolclos).state = true;
                                  context
                                      .read(videoPlayerControllerProvider)
                                      .state
                                      ?.dispose();
                                  videoController =
                                      VideoPlayerController.network(
                                    "https://vz-37aa8c85-08a.b-cdn.net/$videoid/playlist.m3u8",
                                  )..initialize().then((_) {
                                          // setState to update the state provider with the initialized video controller
                                          context
                                              .read(
                                                  videoPlayerControllerProvider)
                                              .state = videoController;
                                          context.read(boolclos).state = false;
                                        });
                                  context
                                      .read(miniPlayerControllerProvider)
                                      .state
                                      .animateToHeight(state: PanelState.MAX);

                                  print('1 done');
                                  context.read(selectedVideoProvider).state =
                                      video1;
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        204, 158, 158, 158),
                                                foregroundImage: NetworkImage(
                                                    "https://vz-37aa8c85-08a.b-cdn.net/$guid/$tumbname"),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                              child: Text(
                                                video1.title.split('/')[2],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ]));
  }

  int selectedOption11 = 0;
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Explore a world of movies! Choose your preferred movie type to discover the latest and greatest films.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(136, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 16),
              ToggleButtons(
                isSelected:
                    List.generate(4, (index) => selectedOption11 == index),
                onPressed: (int index) {
                  Navigator.pop(context); // Close the bottom sheet
                  setState(() {
                    selectedOption11 = index;
                    countfilter = 1;
                    if (index == 0) {
                      select = "";
                      isfilter = false;
                      countfilter = 0;
                      refresh();
                    } else {
                      select = index == 1
                          ? "Action/"
                          : index == 2
                              ? "Mystery/"
                              : "Horror/"; // Adjust as needed
                      isfilter = true;
                      refresh();
                    }

                    print(selectedOption11);
                  });
                },
                fillColor: Colors.amber, // Adjust as needed
                selectedColor: const Color.fromARGB(
                    255, 255, 255, 255), // Change the selected color
                borderColor: Colors.grey.withOpacity(0.7), // Adjust as needed
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderWidth: 1,
                selectedBorderColor: const Color.fromARGB(255, 158, 158, 158)
                    .withOpacity(0.7),
                children: const [
                  SizedBox(
                      width: 100,
                      height: 20,
                      child: Center(
                          child: Text("None",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white)))),
                  SizedBox(
                      width: 70,
                      height: 20,
                      child: Center(
                          child: Text("Action",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white)))),
                  SizedBox(
                      width: 70,
                      height: 20,
                      child: Center(
                          child: Text("Mystery",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white)))),
                  SizedBox(
                      width: 70,
                      height: 20,
                      child: Center(
                          child: Text("Horror",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white)))),
                ], // Adjust as needed
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                    // Close the bottom sheet
                  },
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _searchDelayed(String query3) async {
    // Cancel the previous search request if it exists
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Add a short delay before making the API call
    await Future.delayed(const Duration(milliseconds: 300));

    // Perform the search
    _search(query3);
  }
}

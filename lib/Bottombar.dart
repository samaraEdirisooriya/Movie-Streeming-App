import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:movie/constants.dart';
import 'package:movie/nav_screen.dart';
import 'package:movie/playlistmain.dart';
import 'package:movie/searchbar.dart';
import 'package:movie/settings.dart';
import 'package:movie/trending.dart';
import 'package:movie/videoscreen.dart';
import 'package:movie/watchlaterlist.dart';
import 'package:movie/watchpage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:glassmorphism/glassmorphism.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static const double _playerMinHeight = 75;
  int _currentIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const serchscreen(),
     const HistoryPage(),
      const watchlatter(),
    const Setting(),
    const HistoryPage(),
    const Mainplaylist( ),
  
    
    
    const serchscreen(),
  
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fluter 1.x
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.kBlackColor,
      body: Stack(
        children: [
          Consumer(
            builder: (context, watch, child) {
              final currentIndex = watch(currentIndexProvider).state;
              // Your code for rendering pages based on currentIndex
              return pages[currentIndex];
            },
          ),
          Consumer(
            builder: (context, watch, child) {
              final selectedVideo = watch(selectedVideoProvider).state;
              final miniplayercontroller =
                  watch(miniPlayerControllerProvider).state;
              final videoController =
                  watch(videoPlayerControllerProvider).state;

              final isload = watch(boolclos).state;
              final ab = watch(Ab).state;
              String vid = selectedVideo?.guid ?? "nouse";
              String videoTitle = selectedVideo?.title ?? "No video selected";
              return AbsorbPointer(
                absorbing: ab,
                child: Stack(
                  children: [
                    Offstage(
                      offstage: selectedVideo == null,
                      child: isload
                          ? Miniplayer(
                              controller: miniplayercontroller,
                              maxHeight:
                                  MediaQuery.of(context).size.height - 95,
                              minHeight: _playerMinHeight,
                              builder: (height, percentage) {
                                if (selectedVideo == null) {
                                  Container(
                                    color:
                                        const Color.fromARGB(255, 56, 56, 56),
                                    child: Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 10),
                                        child: Shimmer.fromColors(
                                            baseColor: const Color.fromARGB(
                                                255, 65, 65, 65),
                                            highlightColor: const Color.fromARGB(
                                                160, 141, 141, 141),
                                            child: Container(
                                              width: 200,
                                              height: 90,
                                              color: const Color.fromARGB(
                                                  160, 255, 193, 7),
                                            )),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  color: const Color.fromARGB(255, 32, 32, 32),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 60),
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
                                                  height: 300,
                                                  color: const Color.fromARGB(
                                                      160, 255, 193, 7),
                                                )),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Shimmer.fromColors(
                                                    baseColor: const Color.fromARGB(
                                                        176, 65, 65, 65),
                                                    highlightColor:
                                                        const Color.fromARGB(
                                                            139, 141, 141, 141),
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color
                                                            .fromARGB(
                                                            158, 255, 193, 7),
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: SizedBox(
                                                    child: Shimmer.fromColors(
                                                        baseColor:
                                                            const Color.fromARGB(176,
                                                                65, 65, 65),
                                                        highlightColor:
                                                            const Color.fromARGB(139,
                                                                141, 141, 141),
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
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Miniplayer(
                              controller: miniplayercontroller,
                              maxHeight:
                                  MediaQuery.of(context).size.height - 95,
                              minHeight: _playerMinHeight,
                              builder: (height, percentage) {
                                if (selectedVideo == null) {
                                  return const SizedBox.shrink();
                                }
                                if (height <= _playerMinHeight + 50.0) {
                                  return Container(
                                    color:
                                        const Color.fromARGB(255, 56, 56, 56),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                height: _playerMinHeight,
                                                width: 130.0,
                                                child: Offstage(
                                                  offstage: height >
                                                      _playerMinHeight + 50,
                                                  child: SizedBox(
                                                    height: 70,
                                                    width: 130,
                                                    child: videoController!
                                                            .value.isInitialized
                                                        ? Chewie(
                                                            controller:
                                                                ChewieController(
                                                            showControls: false,
                                                            videoPlayerController:
                                                                videoController,
                                                          ))
                                                        : const CircularProgressIndicator(),
                                                  ),
                                                ) // Additional configurations like aspectRatio, errorBuilder, etc.

                                                ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        selectedVideo.title,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        selectedVideo.guid,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.play_arrow),
                                              onPressed: () {
                                                context
                                                    .read(
                                                        videoPlayerControllerProvider)
                                                    .state
                                                    ?.pause();
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                context
                                                    .read(selectedVideoProvider)
                                                    .state = null;
                                                context
                                                    .read(
                                                        videoPlayerControllerProvider)
                                                    .state
                                                    ?.dispose();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                print(videoController == null);
                                return const VideoPage();
                              }),
                    ),
                  ],
                ),
              ); // Your remaining widget structure
            },
          ),
        ],
      ), // Display the selected page
      floatingActionButton: Container(
        height: 64,
        width: 64,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Constants.kPinkColor.withOpacity(0.2),
              Constants.kGreenColor.withOpacity(0.2)
            ],
          ),
        ),
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Constants.kPinkColor,
                Color.fromARGB(255, 199, 251, 9),
              ],
            ),
          ),
          child: RawMaterialButton(
            onPressed: () {
              context.read(currentIndexProvider).state = 1;
              setState(() {
                _currentIndex = 1;
              });
            },
            shape: const CircleBorder(),
            fillColor: const Color(0xff404c57),
            child: Icon(
              Icons.auto_awesome,
              color: _currentIndex == 1 ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width,
        height: 73,
        borderRadius: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.kWhiteColor.withOpacity(0.1),
            Constants.kWhiteColor.withOpacity(0.1),
          ],
        ),
        border: 0,
        blur: 30,
        borderGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Constants.kPinkColor,
            Color.fromARGB(255, 251, 247, 9),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          notchMargin: 4,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read(currentIndexProvider).state = 0;
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      icon: Icon(
                        Icons.local_fire_department_outlined,
                        size: 30,
                        color: _currentIndex == 0 ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Text(''),
              ),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read(currentIndexProvider).state = 2;
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                      icon: Icon(
                        Icons.blur_circular_sharp,
                        size: 30,
                        color: _currentIndex == 2 ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

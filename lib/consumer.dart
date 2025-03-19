import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:movie/nav_screen.dart';
import 'package:movie/searchbar.dart';
import 'package:movie/videoscreen.dart';



class con extends StatefulWidget {
  const con({super.key});

  @override
  State<con> createState() => _conState();
}

int _currentIndex = 0;
final List<Widget> pages = [
  const Scaffold(),
  
  const serchscreen(),
  Scaffold(
    body: Container(),
  )
];

class _conState extends State<con> {
  static const double _playerMinHeight = 75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_currentIndex],
          Consumer(
            builder: (context, watch, child) {
              final selectedVideo = watch(selectedVideoProvider).state;
              final miniplayercontroller =
                  watch(miniPlayerControllerProvider).state;
              final videoController =
                  watch(videoPlayerControllerProvider).state;
              videoController?.play();
              final isload = watch(boolclos).state;
               final ab = watch(Ab).state;
              String vid = selectedVideo?.guid??"nouse";
              String videoTitle = selectedVideo?.title ?? "No video selected";
              return AbsorbPointer(
                          absorbing:ab ,
                child: Stack(
                  children: [
                    Offstage(
                      offstage: selectedVideo == null,
                      child: isload
                          ? Miniplayer(
                              controller: miniplayercontroller,
                              maxHeight: MediaQuery.of(context).size.height,
                              minHeight: _playerMinHeight,
                              builder: (height, percentage) {
                                if (selectedVideo == null) {
                                  Container(
                                      color:
                                          const Color.fromARGB(255, 56, 56, 56));
                                }
                                return Container(
                                    color: const Color.fromARGB(255, 56, 56, 56));
                              })
                          :  Miniplayer(
                                controller: miniplayercontroller,
                                
                                maxHeight: MediaQuery.of(context).size.height,
                                minHeight: _playerMinHeight,
                                builder: (height, percentage) {
                                  if (selectedVideo == null) {
                                    return const SizedBox.shrink();
                                  }
                                  if (height <= _playerMinHeight + 50.0) {
                                    return Container(
                                      color: const Color.fromARGB(255, 56, 56, 56),
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
                                                      child:
                                                          videoController!.value.isInitialized? Chewie(
                                                controller: ChewieController(
                                                  showControls: false,
                                              videoPlayerController: videoController,
                                              
                                            )):const CircularProgressIndicator(),
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
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          selectedVideo.title,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                              ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          selectedVideo.guid,
                                                          overflow:
                                                              TextOverflow.ellipsis,
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
                                                icon: const Icon(Icons.play_arrow),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
        ],
      ),
    );
  }


}

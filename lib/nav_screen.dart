import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie/home.dart';
import 'package:movie/searchbar.dart';
import 'package:video_player/video_player.dart';
import 'package:miniplayer/miniplayer.dart';


final selectedVideoProvider = StateProvider<CustomVideo?>((ref) => null);
final videoListProvider = StateProvider<List<CustomVideo>>((ref) => []);
final currentIndexProvider = StateProvider<int>((ref) => 0);
final playlistbool = StateProvider<bool>((ref) => false);
final boolclos = StateProvider<bool>((ref) => true);
final Ab = StateProvider<bool>((ref) => false);
final quaality = StateProvider<int>((ref) => 0);
final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);
final videoPlayerControllerProvider = StateProvider<VideoPlayerController?>((ref) => null);


class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;

  int _selectedIndex = 0;

  final _screens = [
    const serchscreen(),
    const Home(),
    const Scaffold(body: Center(child: Text('Add'))),
    const Scaffold(body: Center(child: Text('Subscriptions'))),
    const Scaffold(body: Center(child: Text('Library'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          return Stack(
              children: _screens
                  .asMap()
                  .map((i, screen) => MapEntry(
                        i,
                        Offstage(
                          offstage: _selectedIndex != i,
                          child: screen,
                        ),
                      ))
                  .values
                  .toList()
                ..add(Offstage(
                offstage: selectedVideo==null,
                  child: Miniplayer(
                    maxHeight: MediaQuery.of(context).size.height,
                    minHeight: _playerMinHeight,
                    builder: (height, percentage) {
                      return selectedVideo==null?const SizedBox.shrink(): Container(
                        color: const Color.fromARGB(111, 0, 0, 0),
                        child: Center(
                          child: Text("$height,$percentage"),
                        ),
                      );
                    },
                  ),
                )));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
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

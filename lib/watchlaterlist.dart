import 'package:flutter/material.dart';
import 'package:movie/dbhelper2.dart';
import 'package:movie/home.dart';
import 'package:movie/video_card.dart';



class watchlatter extends StatefulWidget {
  const watchlatter({super.key});

  @override
  State<watchlatter> createState() => _watchlatterState();
}

class _watchlatterState extends State<watchlatter> {
     late Future<List<CustomVideo>> _videos;
 @override

  void initState() {
    super.initState();
    _videos = DatabaseHelper2().getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Liaaaaast'),
      ),
      body: FutureBuilder<List<CustomVideo>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
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
    );
  }
}
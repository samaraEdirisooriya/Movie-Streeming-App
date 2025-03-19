import 'package:flutter/material.dart';
import 'package:movie/databasehelper.dart';
import 'package:movie/home.dart';
import 'package:movie/video_card.dart';


class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final List<CustomVideo> _videos = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchVideos(10,);
  }

  Future<void> _fetchVideos(int count) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<CustomVideo> newVideos = await DatabaseHelper().getVideos(_currentPage, count);
      setState(() {
        _videos.addAll(newVideos);
        _isLoading = false;
        _currentPage++;
      });
    } catch (e) {
      // Add error handling here
      print('Error fetching videos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent && 
        !_isLoading) {
      _fetchVideos(10);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildVideoList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return Column(
          children: [
            Text(video.dateTime),
            VideoCard(video: video),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: _isLoading && _videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildVideoList(),
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class ChewieExample extends StatefulWidget {
  const ChewieExample({Key? key}) : super(key: key);

  @override
  _ChewieExampleState createState() => _ChewieExampleState();
}

class _ChewieExampleState extends State<ChewieExample> {
  late VideoPlayerController videoController;
  ChewieController? chewieController;
  List<String> qualityOptions = ['High Quality (240p)', 'Medium', 'Low'];
  String selectedQuality = 'High Quality (240p)';
  bool isex = false;

  String timeAgo =
      timeago.format(DateTime(2017, 2, 1, 2, 2, 2, 2), locale: 'en');
  @override
  void initState() {
    super.initState();
    initializeVideoController();
    print("donnnnnnnnnnnnnnnnee");
  }
Future<void> initializeVideoController() async {
  videoController = VideoPlayerController.network(
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  );

  try {
    await videoController.initialize();
  } catch (error) {
    if (error is PlatformException) {
      debugPrint("PlatformException occurred: ${error.message}");
      debugPrint("Details: ${error.details}");
      debugPrint("Stack trace: ${error.stacktrace}");
    } else {
      debugPrint("Unexpected error: $error");
    }
    return;
  }

  chewieController = ChewieController(
    videoPlayerController: videoController,
    autoPlay: true,
    looping: false,
  );

  if (mounted) {
    setState(() {});
  }
}

  @override
  void dispose() {
    videoController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.black,
                  height: 255,
                  child: chewieController != null
                      ? Chewie(controller: chewieController!)
                      : Container(),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    progressbars(
                      videoController: videoController,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 330,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10, left: 12),
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "samgmini with options tw droo 2016 kkkkkkkkk k kkkkkkkkkkkkkkkk kkkkkkkkk",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 12,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text('$timeAgo • ',
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 100, 100, 100),
                              fontSize: 14.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 12),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: selectedQuality,
                                  underline: Container(),
                                  borderRadius: BorderRadius.circular(10),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedQuality = newValue!;
                                    });
                                  },
                                  items: qualityOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Divider(
                        height: 1,
                        color: Color.fromARGB(144, 158, 158, 158),
                      ),
                    ),
                    ExpansionTile(
                      onExpansionChanged: (value) {
                        setState(() {
                          isex = value;
                        });
                      },
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Row(
                              children: [
                                const Text(
                                  'Discription',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.orange),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text(
                                      "Action",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          isex
                              ? const Text("")
                              : const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                      "In a not-so-distant future, humanity faces an unprecedented crisis as Earth's resources dwindle. Amidst the chaos, a brilliant scientist, Dr. Olivia Chambers, discovers a mysterious signal from an uncharted exoplanet. Determined to secure humanity's future, she assembles a team of experts for a perilous journey to the far reaches of the galaxy.As they traverse the cosmic unknown, the team encounters extraterrestrial wonders and challenges that push the limits of human understanding. Along the way, personal and collective struggles unfold, testing the bonds that hold the crew together. As they approach the source of the signal, they unravel a cosmic mystery that could change the course of human history.",
                                      textAlign: TextAlign.start,
                                      maxLines: 4,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 100, 100, 100),
                                          fontSize: 14.0)),
                                ),
                        ],
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "In a not-so-distant future, humanity faces an unprecedented crisis as Earth's resources dwindle. Amidst the chaos, a brilliant scientist, Dr. Olivia Chambers, discovers a mysterious signal from an uncharted exoplanet. Determined to secure humanity's future, she assembles a team of experts for a perilous journey to the far reaches of the galaxy.As they traverse the cosmic unknown, the team encounters extraterrestrial wonders and challenges that push the limits of human understanding. Along the way, personal and collective struggles unfold, testing the bonds that hold the crew together. As they approach the source of the signal, they unravel a cosmic mystery that could change the course of human history.",
                            style: TextStyle(
                                fontSize: 16.0,
                                color:
                                    Color.fromARGB(255, 100, 100, 100)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 14, left: 15),
                        child: Text(
                          'PlayList',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class progressbars extends StatefulWidget {
  final VideoPlayerController videoController;
  const progressbars({Key? key, required this.videoController})
      : super(key: key);

  @override
  State<progressbars> createState() => _progressbarsState();
}

class _progressbarsState extends State<progressbars> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

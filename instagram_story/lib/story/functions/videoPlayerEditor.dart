import 'package:instagram_story/story/UI/story_page.dart';

import 'package:video_player/video_player.dart';

import '../data/story_page_data.dart';

//Functions that I have used for video controller

Future<void> play(String url) async {
  if (url.isEmpty) return;
  if (videoController.value.isInitialized) {
    await videoController.dispose();
  }

  videoController = VideoPlayerController.networkUrl(Uri.parse(url));
  return videoController.initialize().then((value) {
    // updateWidgets();
    videoController.play();
    if (videoController.value.duration.inSeconds > 0) {
      videoPlaying = true;
    }
  });
}

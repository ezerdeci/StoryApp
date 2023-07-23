import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../../models/user_model.dart';

//I have used these variables accross the app to make it easier and cleaner

List<User> userList = [];
int userIndex = 0;
List<int> userLeftOffIndex =
    List<int>.filled(userList.length, 0, growable: true);
int currentIndex = 0;
String currentUrl = "";

VideoPlayerController videoController =
    VideoPlayerController.networkUrl(Uri.parse(""));

ValueNotifier<Future<void>?> videoFuture = ValueNotifier(null);

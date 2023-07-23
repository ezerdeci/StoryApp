// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class StoryProgressBar extends StatelessWidget {
  double percentWatched;
  StoryProgressBar({required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 5,
      percent: percentWatched,
      backgroundColor: Color.fromARGB(255, 65, 64, 64),
      progressColor: Color.fromARGB(255, 143, 143, 143),
    );
  }
}

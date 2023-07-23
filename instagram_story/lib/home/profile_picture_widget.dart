import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ProfilePictureWidget extends StatelessWidget {
  final User user;
  final function;

  const ProfilePictureWidget({super.key, required this.user, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 35,
          backgroundColor: const Color.fromARGB(255, 153, 153, 153),
          backgroundImage: NetworkImage(user.profileUrl),
        ),
      ),
    );
  }
}

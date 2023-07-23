import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story/home/bloc/home_bloc.dart';
import 'package:instagram_story/home/profile_picture_widget.dart';

import '../story/UI/story_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeNavigationState,
      buildWhen: (previous, current) => current is! HomeNavigationState,
      listener: (context, state) {
        if (state is NavigateToStoryPageState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StoryPage()));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeInitial:
            return Scaffold();

          case HomeScreenLoadedState:
            final loadedState = state as HomeScreenLoadedState;
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 59, 59, 59),
              appBar: AppBar(
                title: Text(
                  "My Stories",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                titleTextStyle: TextStyle(fontSize: 25),
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 26, 26, 26),
              ),
              body: SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: loadedState.userList.length,
                    itemBuilder: (context, index) {
                      return ProfilePictureWidget(
                          user: loadedState.userList[index],
                          function: () {
                            homeBloc.add(ProfileTappedEvent(
                                loadedState.userList, index));
                          });
                    }),
              ),
            );
          default:
            return Scaffold();
        }
      },
    );
  }
}

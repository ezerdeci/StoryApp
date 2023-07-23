part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeNavigationState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeScreenLoadedState extends HomeState {
  final List<User> userList;

  HomeScreenLoadedState({
    required this.userList,
  });
}

class NavigateToStoryPageState extends HomeNavigationState {}

part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ProfileTappedEvent extends HomeEvent {
  final List<User> userList;
  final int index;

  ProfileTappedEvent(this.userList, this.index);
}

class HomeInitialEvent extends HomeEvent {}

class StoryModel {
  final String storyOwner;
  final String mediaType;
  final String url;
  final double duration;
  double percentWatched = 0;

  StoryModel(
    this.storyOwner,
    this.mediaType,
    this.url,
    this.duration,
  );
}

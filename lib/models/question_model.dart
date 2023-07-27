class Question {
  // define how a question will look like
  // every question will have an Id.
  final String id;
  // every question will have a title, it's the question itself.
  final String title;
  // every question will have options.
  final Map<String, bool> options;
  // options will be like - {'1':true, '2':false} = something like these
  final bool photo;
  final String url;
  final String explain;
  // create a constructor
  Question(
      {required this.id,
      required this.photo,
      required this.title,
      required this.options,
      this.url = '',
      this.explain = ''});
}

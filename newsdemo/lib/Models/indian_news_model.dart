class IndianNewsModel {
  final String title;
  final String content;

  IndianNewsModel({required this.title, required this.content});

  factory IndianNewsModel.fromJson(Map<String, dynamic> json) {
    return IndianNewsModel(
      title: json['title'],
      content: json['content'],
    );
  }
}

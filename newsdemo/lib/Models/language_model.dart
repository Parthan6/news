class LanguageNewsModel {
  final String title;
  final String link;

  LanguageNewsModel({required this.title, required this.link});

  factory LanguageNewsModel.fromJson(Map<String, dynamic> json) {
    return LanguageNewsModel(
      title: json['title'],
      link: json['link'],
    );
  }
}

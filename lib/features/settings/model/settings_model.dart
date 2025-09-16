class SettingsModel {
  final int id;
  final String title;
  final String subtitle;
  final String pageSlug;

  SettingsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pageSlug,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      pageSlug: json['page_slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'page_slug': pageSlug,
    };
  }
}

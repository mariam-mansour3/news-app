import 'package:hive/hive.dart';
import '../../domain/entities/article.dart';

part 'article_hive_model.g.dart';

@HiveType(typeId: 0)
class ArticleHiveModel extends Article {
  @HiveField(0)
  final String hiveTitle;

  @HiveField(1)
  final String hiveDescription;

  @HiveField(2)
  final String hiveUrl;

  @HiveField(3)
  final String? hiveUrlToImage;

  @HiveField(4)
  final String hivePublishedAt;

  @HiveField(5)
  final String hiveSource;

  @HiveField(6)
  final String? hiveAuthor;

  @HiveField(7)
  final String? hiveContent;

  ArticleHiveModel({
    required this.hiveTitle,
    required this.hiveDescription,
    required this.hiveUrl,
    this.hiveUrlToImage,
    required this.hivePublishedAt,
    required this.hiveSource,
    this.hiveAuthor,
    this.hiveContent,
  }) : super(
          title: hiveTitle,
          description: hiveDescription,
          url: hiveUrl,
          urlToImage: hiveUrlToImage,
          publishedAt: _parseDate(hivePublishedAt),
          source: hiveSource,
          author: hiveAuthor,
          content: hiveContent,
        );

  // Helper method to parse date
  static DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  factory ArticleHiveModel.fromJson(Map<String, dynamic> json) {
    return ArticleHiveModel(
      hiveTitle: json['title'] ?? '',
      hiveDescription: json['description'] ?? '',
      hiveUrl: json['url'] ?? '',
      hiveUrlToImage: json['urlToImage'],
      hivePublishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      hiveSource: json['source']?['name'] ?? 'Unknown',
      hiveAuthor: json['author'],
      hiveContent: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': hiveTitle,
        'description': hiveDescription,
        'url': hiveUrl,
        'urlToImage': hiveUrlToImage,
        'publishedAt': hivePublishedAt,
        'source': {'name': hiveSource},
        'author': hiveAuthor,
        'content': hiveContent,
      };

  factory ArticleHiveModel.fromEntity(Article article) {
    return ArticleHiveModel(
      hiveTitle: article.title,
      hiveDescription: article.description,
      hiveUrl: article.url,
      hiveUrlToImage: article.urlToImage,
      hivePublishedAt: article.publishedAt.toIso8601String(),
      hiveSource: article.source,
      hiveAuthor: article.author,
      hiveContent: article.content,
    );
  }

  Article toEntity() {
    return Article(
      title: hiveTitle,
      description: hiveDescription,
      url: hiveUrl,
      urlToImage: hiveUrlToImage,
      publishedAt: _parseDate(hivePublishedAt),
      source: hiveSource,
      author: hiveAuthor,
      content: hiveContent,
    );
  }
}

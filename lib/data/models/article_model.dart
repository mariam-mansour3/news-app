import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/article.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.url,
    super.urlToImage,
    required super.publishedAt,
    required super.source,
    super.author,
    super.content,
  });

  // Use the generated function and handle special cases
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Handle the source field specially since API returns nested object
    final processedJson = Map<String, dynamic>.from(json);
    if (processedJson['source'] is Map) {
      processedJson['source'] = processedJson['source']?['name'] ?? 'Unknown';
    }

    // Handle null/empty values
    processedJson['title'] = processedJson['title'] ?? '';
    processedJson['description'] = processedJson['description'] ?? '';
    processedJson['url'] = processedJson['url'] ?? '';
    processedJson['publishedAt'] =
        processedJson['publishedAt'] ?? DateTime.now().toIso8601String();

    return _$ArticleModelFromJson(processedJson);
  }

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  // Factory method for converting entity to model (Mapper pattern)
  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      title: article.title,
      description: article.description,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      source: article.source,
      author: article.author,
      content: article.content,
    );
  }
}

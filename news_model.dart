

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishedDate;
  final String category;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'publishedDate': publishedDate.toIso8601String(),
      'category': category,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      publishedDate: DateTime.parse(json['publishedDate']),
      category: json['category'],
    );
  }

  bool isNew() {
    final now = DateTime.now();
    final difference = now.difference(publishedDate);
    return difference.inDays <= 7;
  }

  String getPreview() {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? publishedDate,
    String? category,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      category: category ?? this.category,
    );
  }

  static fromFirestore(String id, Map<String, dynamic> data) {}
}
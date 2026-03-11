class BucketListItem {
  final String id;
  final String title;
  final String? hindiTitle;
  final bool isCompleted;

  BucketListItem({
    required this.id,
    required this.title,
    this.hindiTitle,
    this.isCompleted = false,
  });

  BucketListItem copyWith({
    String? id,
    String? title,
    String? hindiTitle,
    bool? isCompleted,
  }) {
    return BucketListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      hindiTitle: hindiTitle ?? this.hindiTitle,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'hindiTitle': hindiTitle,
      'isCompleted': isCompleted,
    };
  }

  factory BucketListItem.fromMap(Map<String, dynamic> map) {
    return BucketListItem(
      id: map['id'] as String,
      title: map['title'] as String,
      hindiTitle: map['hindiTitle'] as String?,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}

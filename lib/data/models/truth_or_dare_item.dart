enum TodCategory {
  romanticTruth,
  spicyTruth,
  romanticDare,
  spicyDare,
  kissing,
  intimate,
  immersive,
}

class TruthOrDareItem {
  final String id;
  final TodCategory category;
  final String content;
  final String? imageUrl;
  final String? hindiContent;

  const TruthOrDareItem({
    required this.id,
    required this.category,
    required this.content,
    this.imageUrl,
    this.hindiContent,
  });
}

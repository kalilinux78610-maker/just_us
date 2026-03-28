enum TodCategory {
  romanticTruth,
  spicyTruth,
  romanticDare,
  spicyDare,
  kissing,
  intimate,
  immersive,
  stickerDare,
  longDistance,
  inPerson,
  truth,
}

class TruthOrDareItem {
  final String id;
  final TodCategory category;
  final String content;
  final String? imageUrl;
  final String? lottiePath;
  final String? hindiContent;

  const TruthOrDareItem({
    required this.id,
    required this.category,
    required this.content,
    this.imageUrl,
    this.lottiePath,
    this.hindiContent,
  });
}

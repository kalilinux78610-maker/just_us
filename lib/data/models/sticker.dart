class Sticker {
  final String id;
  final String name;
  final String description;
  final String icon; // Could be a FontAwesomeIcon or an asset path
  final int requiredScore;

  const Sticker({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredScore,
  });
}

import '../l10n/localized_label.dart';

class Region {
  final LocalizedLabel name;
  final int firstId, lastId;
  final List<String> starters;

  Region({
    required this.name,
    required this.firstId,
    required this.lastId,
    required this.starters,
  });
}

class PokemonDetail {
  final int weight;
  final int height;
  final List<String> types;

  PokemonDetail({
    required this.weight,
    required this.height,
    required this.types,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    // On fait le traitement complexe des types ici, côté "Data" !
    List<String> extractedTypes = (json['types'] as List)
        .map((t) => t['type']['name'].toString().toUpperCase())
        .toList();

    return PokemonDetail(
      weight: json['weight'],
      height: json['height'],
      types: extractedTypes,
    );
  }
}
class PokemonForm {
  final int id;
  final String name;

  PokemonForm({
    required this.id,
    required this.name,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json, [int? provideId]) {
    final data = json.containsKey('pokemon') ? json['pokemon'] : json;
    
    String urlString = data['url'];
    int calculatedId = int.parse(urlString.split('/')[urlString.split('/').length - 2]);


    return PokemonForm(
      id: calculatedId,
      name: data['name'],
    );
  }
}
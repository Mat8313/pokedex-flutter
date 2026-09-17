class PokemonForm {
  final String url;
  final String name;

  PokemonForm({
    required this.name,
    required this.url,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json, [int? provideId]) {

    return PokemonForm(
      name : json['pokemon']['name'],
      url  : json['pokemon']['url'],
    );
  }
}
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int? height; // Optionnel car absent de la liste principale
  final int? weight; // Optionnel car absent de la liste principale

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height,
    this.weight,
  });

  // On ajoute [int? providedId] entre crochets pour dire que le 2ème argument est optionnel
  factory Pokemon.fromJson(Map<String, dynamic> json, [int? providedId]) {
    // Si le service fournit un ID, on l'utilise. Sinon on le cherche dans le JSON.
    final int id = providedId ?? json['id'];
    
    return Pokemon(
      id: id,
      name: json['name'],
      // On génère l'URL du sprite officiel de la PokéAPI grâce à l'ID
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      height: json['height'],
      weight: json['weight'],
    );
  }
}
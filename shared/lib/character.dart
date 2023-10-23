class Character {
  final String name;
  final String description;
  final String? iconUrl;

  Character({
    required this.name,
    required this.description,
    this.iconUrl,
  });

  // TODO: Better error handling
  factory Character.fromJson(Map<String, dynamic> json) {
    String name = json['Text'].split(' - ')[0];
    String description = json['Text'].split(' - ').length > 1
        ? json['Text'].split(' - ')[1]
        : 'No description available';
    String iconUrl = "https://duckduckgo.com/${json['Icon']['URL'] ?? ''}";
    return Character(name: name, description: description, iconUrl: iconUrl);
  }
}

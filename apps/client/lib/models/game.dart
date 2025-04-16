class Game {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? image;
  final int? publishYear;
  final int? minPlayers;
  final int? maxPlayers;
  final int? playingTime;
  final bool isFromExternal;
  final String? externalId;
  final String? externalSource;

  Game({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.image,
    this.publishYear,
    this.minPlayers,
    this.maxPlayers,
    this.playingTime,
    this.isFromExternal = false,
    this.externalId,
    this.externalSource,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      image: json['image'],
      publishYear: json['publishYear'],
      minPlayers: json['minPlayers'],
      maxPlayers: json['maxPlayers'],
      playingTime: json['playingTime'],
      isFromExternal: json['isFromExternal'] ?? false,
      externalId: json['externalId'],
      externalSource: json['externalSource'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
      'publishYear': publishYear,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'playingTime': playingTime,
      'isFromExternal': isFromExternal,
      'externalId': externalId,
      'externalSource': externalSource,
    };
  }
}

import './game.dart';

class GameCollection {
  final String id;
  final String userId;
  final Game game;
  final int quantity;
  final int? rating;
  final int? playCount;
  final bool? playAgain;
  final bool? favorite;
  final String? comment;
  final DateTime? lastPlayed;
  final DateTime? lastUpdated;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameCollection({
    required this.id,
    required this.userId,
    required this.game,
    required this.quantity,
    this.rating,
    this.playCount,
    this.playAgain,
    this.favorite,
    this.comment,
    this.lastPlayed,
    this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameCollection.fromJson(Map<String, dynamic> json) {
    return GameCollection(
      id: json['id'],
      userId: json['userId'],
      game: Game.fromJson(json['game']),
      quantity: json['quantity'],
      rating: json['rating'],
      playCount: json['playCount'],
      playAgain: json['playAgain'],
      favorite: json['favorite'],
      comment: json['comment'],
      lastPlayed:
          json['lastPlayed'] != null
              ? DateTime.parse(json['lastPlayed'])
              : null,
      lastUpdated:
          json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'])
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'game': game.toJson(),
      'quantity': quantity,
      'rating': rating,
      'playCount': playCount,
      'playAgain': playAgain,
      'favorite': favorite,
      'comment': comment,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/game.dart';
import '../../models/search_result.dart';
import 'package:http_status/http_status.dart';

class GameRestService {
  final String baseUrl;

  GameRestService({required this.baseUrl});

  Future<SearchResult> searchGames(String query, String externalSource) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/games/search?query=$query&externalSource=$externalSource',
      ),
    );

    if (response.statusCode == HttpStatusCode.ok) {
      return SearchResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search games: ${response.body}');
    }
  }

  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    String url = '$baseUrl/games/$gameId';
    if (isExternal) {
      url += '?isExternal=true&externalSource=$externalSource';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatusCode.ok) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get game details: ${response.body}');
    }
  }

  Future<Game> addGame(Game game) async {
    final response = await http.post(
      Uri.parse('$baseUrl/games'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (response.statusCode == HttpStatusCode.created) {
      return Game.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to add game: ${response.body}');
  }
}

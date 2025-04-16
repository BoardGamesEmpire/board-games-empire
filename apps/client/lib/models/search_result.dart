import './game.dart';

class SearchResult {
  final List<Game> internalResults;
  final List<Game> externalResults;
  final String searchTerm;
  final String? externalSource;

  SearchResult({
    required this.internalResults,
    required this.externalResults,
    required this.searchTerm,
    this.externalSource,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      internalResults:
          (json['internalResults'] as List)
              .map((i) => Game.fromJson(i))
              .toList(),
      externalResults:
          (json['externalResults'] as List)
              .map((i) => Game.fromJson(i))
              .toList(),
      searchTerm: json['searchTerm'],
      externalSource: json['externalSource'],
    );
  }
}

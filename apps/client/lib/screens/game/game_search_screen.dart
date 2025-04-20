import 'package:flutter/material.dart';

import '../../di/injection.dart';
import '../../models/game/game.dart';
import '../../models/search_result.dart';
import '../../services/game/game_service.dart';
import '../../services/websocket/websocket_manager.dart';

class GameSearchScreen extends StatefulWidget {
  static const routeName = '/games/search';

  const GameSearchScreen({super.key});

  @override
  _GameSearchScreenState createState() => _GameSearchScreenState();
}

class _GameSearchScreenState extends State<GameSearchScreen> {
  final GameService _gameService = getIt<GameService>();
  final WebSocketManager _websocketManager = getIt<WebSocketManager>();

  final TextEditingController _searchController = TextEditingController();

  String _selectedExternalSource = 'BoardGameGeek';
  SearchResult? _searchResult;
  bool _isLoading = false;

  final List<String> _externalSources = [
    'BoardGameGeek',
    'IGDB',
    'Steam',
    'None',
  ];

  @override
  void initState() {
    super.initState();

    _gameService.searchResultsStream.listen((result) {
      if (mounted) {
        setState(() {
          _searchResult = result;
        });
      }
    });
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _gameService.searchGames(
        query,
        _selectedExternalSource,
      );
      if (mounted) {
        setState(() {
          _searchResult = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _addGame(Game game) async {
    try {
      final addedGame = await _gameService.addGame(game);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${addedGame.title} added to collection')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add game: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Search'),
        actions: [
          // WebSocket status indicator
          StreamBuilder<bool>(
            stream: _websocketManager.statusStream,
            initialData: _websocketManager.isConnected,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Tooltip(
                message:
                    isConnected
                        ? 'Using WebSocket for real-time results'
                        : 'Using REST API',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isConnected ? Icons.bolt : Icons.sync,
                    color: isConnected ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for games...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),

                      // Show WebSocket status on the search field
                      suffixIcon: StreamBuilder<bool>(
                        stream: _websocketManager.statusStream,
                        initialData: _websocketManager.isConnected,
                        builder: (context, snapshot) {
                          final isConnected = snapshot.data ?? false;
                          return Icon(
                            isConnected ? Icons.bolt : Icons.http,
                            color: isConnected ? Colors.green : Colors.orange,
                          );
                        },
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedExternalSource,
                  items:
                      _externalSources.map((source) {
                        return DropdownMenuItem(
                          value: source,
                          child: Text(source),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedExternalSource = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_searchResult != null)
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          text:
                              'Internal (${_searchResult!.internalResults.length})',
                        ),
                        Tab(
                          text:
                              'External (${_searchResult!.externalResults.length})',
                        ),
                      ],
                      labelColor: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Internal results
                          _buildResultsList(
                            _searchResult!.internalResults,
                            true,
                          ),

                          // External results
                          _buildResultsList(
                            _searchResult!.externalResults,
                            false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsList(List<Game> games, bool isInternal) {
    if (games.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading:
                game.image != null
                    ? Image.network(
                      game.image!,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    )
                    : const Icon(Icons.games, size: 50),
            title: Text(game.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (game.publishYear != null)
                  Text('Published: ${game.publishYear}'),
                if (game.minPlayers != null && game.maxPlayers != null)
                  Text('Players: ${game.minPlayers}-${game.maxPlayers}'),
                if (game.playingTime != null)
                  Text('Time: ${game.playingTime} min'),
              ],
            ),
            trailing:
                isInternal
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : ElevatedButton(
                      onPressed: () => _addGame(game),
                      child: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
            isThreeLine: true,
            onTap: () => _showGameDetails(game),
          ),
        );
      },
    );
  }

  void _showGameDetails(Game game) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  game.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                if (game.subtitle != null)
                  Text(
                    game.subtitle!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                const SizedBox(height: 16),

                if (game.description != null)
                  Text(
                    game.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (game.publishYear != null)
                      Chip(label: Text('${game.publishYear}')),
                    const SizedBox(width: 8),
                    if (game.minPlayers != null && game.maxPlayers != null)
                      Chip(
                        label: Text(
                          '${game.minPlayers}-${game.maxPlayers} players',
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (game.playingTime != null)
                      Chip(label: Text('${game.playingTime} min')),
                  ],
                ),
                const SizedBox(height: 24),
                if (game.isFromExternal)
                  ElevatedButton(
                    onPressed: () => _addGame(game),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Add to Collection'),
                  ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

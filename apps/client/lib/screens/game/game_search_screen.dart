import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/game/game_search/game_search_bloc.dart';
import '../../models/game/game.dart';
import '../../router/route_constants.dart';

class GameSearchScreenBloc extends StatefulWidget {
  static const routeName = AppRoutes.gameSearch;

  const GameSearchScreenBloc({super.key});

  @override
  State<GameSearchScreenBloc> createState() => _GameSearchScreenBlocState();
}

class _GameSearchScreenBlocState extends State<GameSearchScreenBloc> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _externalSources = [
    'BoardGameGeek',
    'IGDB',
    'Steam',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    context.read<GameSearchBloc>().add(
      GameSearchQueryChanged(_searchController.text),
    );
  }

  void _performSearch() {
    context.read<GameSearchBloc>().add(const GameSearchRequested());
  }

  void _changeExternalSource(String? source) {
    if (source != null) {
      context.read<GameSearchBloc>().add(GameSearchSourceChanged(source));
    }
  }

  void _addGame(Game game) {
    context.read<GameSearchBloc>().add(GameAddRequested(game));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Search'),
        actions: [
          // WebSocket status indicator
          BlocBuilder<GameSearchBloc, GameSearchState>(
            buildWhen:
                (previous, current) =>
                    previous.isWebSocketConnected !=
                    current.isWebSocketConnected,
            builder: (context, state) {
              final isConnected = state.isWebSocketConnected;
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
                      suffixIcon: BlocBuilder<GameSearchBloc, GameSearchState>(
                        buildWhen:
                            (previous, current) =>
                                previous.isWebSocketConnected !=
                                current.isWebSocketConnected,
                        builder: (context, state) {
                          final isConnected = state.isWebSocketConnected;
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
                BlocBuilder<GameSearchBloc, GameSearchState>(
                  buildWhen:
                      (previous, current) =>
                          previous.externalSource != current.externalSource,
                  builder: (context, state) {
                    return DropdownButton<String>(
                      value: state.externalSource,
                      items:
                          _externalSources.map((source) {
                            return DropdownMenuItem(
                              value: source,
                              child: Text(source),
                            );
                          }).toList(),
                      onChanged: _changeExternalSource,
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<GameSearchBloc, GameSearchState>(
            buildWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.searchResult != current.searchResult,
            builder: (context, state) {
              if (state.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state.isSuccess && state.searchResult != null) {
                return Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(
                              text:
                                  'Internal (${state.internalResults.length})',
                            ),
                            Tab(
                              text:
                                  'External (${state.externalResults.length})',
                            ),
                          ],
                          labelColor: Theme.of(context).primaryColor,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Internal results
                              _buildResultsList(
                                state.internalResults,
                                true,
                                state.addingGameId,
                              ),

                              // External results
                              _buildResultsList(
                                state.externalResults,
                                false,
                                state.addingGameId,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state.isFailure) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Search error: ${state.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _performSearch,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state.query.isNotEmpty && state.isSuccess) {
                return const Expanded(
                  child: Center(child: Text('No results found')),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text('Enter a search term to find games'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(
    List<Game> games,
    bool isInternal,
    String? addingGameId,
  ) {
    if (games.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        final isAddingThisGame = game.id == addingGameId;

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
                    : isAddingThisGame
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : ElevatedButton(
                      onPressed: () => _addGame(game),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Add'),
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
                  BlocBuilder<GameSearchBloc, GameSearchState>(
                    buildWhen:
                        (previous, current) =>
                            previous.addingGameId != current.addingGameId,
                    builder: (context, state) {
                      final isAddingThisGame = game.id == state.addingGameId;

                      return ElevatedButton(
                        onPressed:
                            isAddingThisGame ? null : () => _addGame(game),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child:
                            isAddingThisGame
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Add to Collection'),
                      );
                    },
                  ),
              ],
            ),
          ),
    );
  }
}

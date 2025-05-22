import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/game/game_gateway/game_gateway_bloc.dart';
import '../../../models/game/game_gateway.dart';
import '../../../widgets/connectivity/connectivity_status_bar.dart';
import '../../../widgets/ui/loading_overlay.dart';
import '../../../widgets/ui/error_display.dart';
import '../../../widgets/ui/confirmation_dialog.dart';
import '../../../widgets/game/game_gateway_list_item.dart';
import '../../../widgets/game/game_gateway_detail.dart';
import 'widgets/form.dart';

class GameGatewayScreen extends StatefulWidget {
  const GameGatewayScreen({super.key});

  @override
  State<GameGatewayScreen> createState() => _GameGatewayScreenState();
}

class _GameGatewayScreenState extends State<GameGatewayScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    context.read<GameGatewayBloc>().add(const GameGatewayInitialized());

    _searchController.addListener(() {
      context.read<GameGatewayBloc>().add(
        GameGatewaySearchQueryChanged(_searchController.text),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final state = context.read<GameGatewayBloc>().state;
    if (_searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      context.read<GameGatewayBloc>().add(
        GameGatewayTabChanged(_tabController.index),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameGatewayBloc, GameGatewayState>(
      listenWhen:
          (previous, current) =>
              previous.currentTabIndex != current.currentTabIndex,
      listener: (context, state) {
        if (state.currentTabIndex != _tabController.index) {
          _tabController.animateTo(state.currentTabIndex);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ConnectivityStatusBar(
            title: const Text('Game Gateways'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'Sources'),
                Tab(icon: Icon(Icons.add), text: 'Add New'),
                Tab(icon: Icon(Icons.edit), text: 'Edit'),
              ],
            ),
          ),
          body: LoadingOverlay(
            isLoading: state.isOperationInProgress,
            loadingText: _getLoadingText(state),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab(context, state),
                _buildAddTab(context, state),
                _buildEditTab(context, state),
              ],
            ),
          ),
          floatingActionButton:
              _tabController.index == 0
                  ? FloatingActionButton(
                    onPressed: () => _tabController.animateTo(1),
                    tooltip: 'Add New Source',
                    child: const Icon(Icons.add),
                  )
                  : null,
        );
      },
    );
  }

  String? _getLoadingText(GameGatewayState state) {
    if (state.isLoading) return 'Loading sources...';
    if (state.isCreating) return 'Creating source...';
    if (state.isUpdating) return 'Updating source...';
    if (state.isDeleting) return 'Deleting source...';
    return null;
  }

  Widget _buildListTab(BuildContext context, GameGatewayState state) {
    if (state.isError) {
      return ErrorDisplay(
        message: state.error ?? 'Failed to load game gateways',
        onRetry:
            () => context.read<GameGatewayBloc>().add(
              const GameGatewayLoadRequested(),
            ),
      );
    }

    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sources...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        state.searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<GameGatewayBloc>().add(
                                  const GameGatewaySearchQueryChanged(''),
                                );
                              },
                            )
                            : null,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter options
                Row(
                  children: [
                    // Auth type filter
                    Flexible(
                      fit: FlexFit.loose,
                      child: DropdownButtonFormField<AuthType?>(
                        value: state.filterAuthType,
                        decoration: const InputDecoration(
                          labelText: 'Auth Type Filter',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<AuthType?>(
                            value: null,
                            child: Text('All Auth Types'),
                          ),
                          ...AuthType.values.map((type) {
                            return DropdownMenuItem<AuthType?>(
                              value: type,
                              child: Text(type.toString().split('.').last),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          context.read<GameGatewayBloc>().add(
                            GameGatewayFilterAuthTypeChanged(value),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Active only filter
                    Flexible(
                      fit: FlexFit.loose,
                      child: CheckboxListTile(
                        title: const Text('Enabled Only'),
                        value: state.filterEnabledOnly,
                        onChanged: (value) {
                          context.read<GameGatewayBloc>().add(
                            GameGatewayFilterEnabledChanged(value ?? false),
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reset filters button
          if (state.searchQuery.isNotEmpty ||
              state.filterAuthType != null ||
              state.filterEnabledOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Reset Filters'),
                  onPressed: () {
                    _searchController.clear(); // Clear the text controller
                    context.read<GameGatewayBloc>().add(
                      const GameGatewayClearFilters(),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

          // List content
          Flexible(
            fit: FlexFit.loose,
            child:
                state.filteredGateways.isEmpty
                    ? ErrorDisplay.empty(
                      message:
                          state.gateways.isEmpty
                              ? 'No game gateways found. Add your first one!'
                              : 'No sources match your filters.',
                      title: 'No Sources Found',
                      icon: Icons.source,
                      actionLabel:
                          state.gateways.isEmpty
                              ? 'Add New Source'
                              : 'Clear Filters',
                      onAction:
                          state.gateways.isEmpty
                              ? () => _tabController.animateTo(1)
                              : () {
                                _searchController.clear();
                                context.read<GameGatewayBloc>().add(
                                  const GameGatewayClearFilters(),
                                );
                              },
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredGateways.length,
                      itemBuilder: (context, index) {
                        final gateway = state.filteredGateways[index];
                        return GameGatewayListItem(
                          gateway: gateway,
                          onTap: () {
                            _showGatewayDetails(context, gateway);
                          },
                          onEdit: () {
                            context.read<GameGatewayBloc>().add(
                              GameGatewaySelectedForEdit(gateway),
                            );
                          },
                          onDelete: () => _confirmDelete(context, gateway),
                          onEnabledChanged: (value) {
                            context.read<GameGatewayBloc>().add(
                              GameGatewayEnableToggled(gateway.id!, value),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showGatewayDetails(BuildContext context, GameGateway gateway) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
            child: GameGatewayDetail(
              gateway: gateway,
              onEdit: () {
                context.pop();
                context.read<GameGatewayBloc>().add(
                  GameGatewaySelectedForEdit(gateway),
                );
              },
              onDelete: () {
                context.pop();
                _confirmDelete(context, gateway);
              },
              onEnabledChanged: (value) {
                context.pop();
                context.read<GameGatewayBloc>().add(
                  GameGatewayEnableToggled(gateway.id!, value),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, GameGateway gateway) async {
    final confirmed = await ConfirmationDialog.delete(
      context,
      itemType: 'Game Gateway',
      onConfirm: () {},
      message:
          'Are you sure you want to delete "${gateway.name}"? This will permanently remove this source and cannot be undone.',
    );

    if (confirmed) {
      if (context.mounted) {
        context.read<GameGatewayBloc>().add(
          GameGatewayDeleteRequested(gateway.id!),
        );
      }
    }
  }

  Widget _buildAddTab(BuildContext context, GameGatewayState state) {
    return GatewayForm(
      isEdit: false,
      onSubmit: (gateway) {
        if (kDebugMode) {
          print('Submitting new gateway: $gateway');
        }

        context.read<GameGatewayBloc>().add(
          GameGatewayCreateRequested(gateway),
        );
      },
      onAuthTypeChanged: (authType) {
        context.read<GameGatewayBloc>().add(
          GameGatewayAuthTypeChanged(authType),
        );
      },
      onFormValidated: (isValid) {
        context.read<GameGatewayBloc>().add(GameGatewayFormValidated(isValid));
      },
    );
  }

  Widget _buildEditTab(BuildContext context, GameGatewayState state) {
    if (state.selectedGateway == null) {
      return ErrorDisplay.empty(
        message: 'Please select a game gateway to edit',
        title: 'No Source Selected',
        icon: Icons.edit,
        showRetryButton: false,
      );
    }

    return GatewayForm(
      isEdit: true,
      initialGateway: state.selectedGateway,
      initialAuthType: state.currentAuthType,
      onSubmit: (gateway) {
        context.read<GameGatewayBloc>().add(
          GameGatewayUpdateRequested(gateway),
        );
      },
      onAuthTypeChanged: (authType) {
        context.read<GameGatewayBloc>().add(
          GameGatewayAuthTypeChanged(authType),
        );
      },
      onFormValidated: (isValid) {
        context.read<GameGatewayBloc>().add(GameGatewayFormValidated(isValid));
      },
    );
  }
}

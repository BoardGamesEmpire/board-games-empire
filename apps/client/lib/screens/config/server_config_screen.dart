import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/server/server_config/server_config_bloc.dart';
import '../../router/route_constants.dart';
import '../../widgets/ui/custom_text_field.dart';

class ServerConfigScreenBloc extends StatefulWidget {
  static const routeName = AppRoutes.serverConfig;
  final bool isInitialSetup;
  final String? serverId;
  final String? initialName;
  final String? initialUrl;

  const ServerConfigScreenBloc({
    super.key,
    this.isInitialSetup = false,
    this.serverId,
    this.initialName,
    this.initialUrl,
  });

  @override
  State<ServerConfigScreenBloc> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends State<ServerConfigScreenBloc> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  bool get isEditMode => widget.serverId != null;

  @override
  void initState() {
    super.initState();
    context.read<ServerConfigBloc>().add(const ServerConfigInitialized());

    if (isEditMode && widget.initialName != null && widget.initialUrl != null) {
      _nameController.text = widget.initialName!;
      _urlController.text = widget.initialUrl!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServerConfigBloc, ServerConfigState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.error != current.error,
      listener: (context, state) {
        if (state.error != null) {
          _showErrorSnackBar(state.error!);
        } else if (state.status == ServerConfigStatus.serverAdded ||
            state.status == ServerConfigStatus.serverUpdated) {
          // On success, navigate back or to login
          if (widget.isInitialSetup) {
            context.goNamed(AppRouteNames.login);
          } else {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditMode
                  ? 'Edit Server'
                  : widget.isInitialSetup
                  ? 'Welcome to Board Games Empire'
                  : 'Add Server',
            ),
            elevation: 0,
            automaticallyImplyLeading: !widget.isInitialSetup,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildForm(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(ServerConfigState state) {
    final isSubmitting =
        state.isAddingServer || state.isUpdatingServer || state.isValidating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isInitialSetup) ...[
          const SizedBox(height: 24),
          Image.asset('images/logo.png', height: 100),
          const SizedBox(height: 24),
          Text(
            'Connect to Your Server',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Please enter the address of your Board Games Empire server to get started.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Server Name (Optional)',
                hintText: 'My Home Server',
                prefixIcon: Icons.label_outline,
                enabled: !isSubmitting,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _urlController,
                labelText: 'Server URL',
                hintText: 'https://my-server.example.com',
                prefixIcon: Icons.link,
                keyboardType: TextInputType.url,
                enabled: !isSubmitting,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a server URL';
                  }

                  String url = value.trim();
                  if (!url.startsWith('http://') &&
                      !url.startsWith('https://')) {
                    url = 'https://$url';
                  }

                  try {
                    Uri.parse(url);
                    return null;
                  } catch (e) {
                    return 'Please enter a valid URL';
                  }
                },
              ),

              if (state.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    state.error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : _testConnection,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state.isValidating
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline),
                              const SizedBox(width: 8),
                              const Text('Test Connection'),
                              if (state.validationSuccessful) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ],
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      isSubmitting || !state.validationSuccessful
                          ? null
                          : _submitServer,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state.isAddingServer || state.isUpdatingServer
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            isEditMode
                                ? 'Update Server'
                                : widget.isInitialSetup
                                ? 'Connect and Continue'
                                : 'Add Server',
                          ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _testConnection() {
    if (_formKey.currentState!.validate()) {
      final url = _urlController.text.trim();
      context.read<ServerConfigBloc>().add(
        ServerConfigValidationRequested(url),
      );
    }
  }

  void _submitServer() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final url = _urlController.text.trim();

      if (isEditMode) {
        context.read<ServerConfigBloc>().add(
          ServerConfigUpdated(serverId: widget.serverId!, name: name, url: url),
        );
      } else {
        context.read<ServerConfigBloc>().add(
          ServerConfigAdded(name: name, url: url),
        );
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

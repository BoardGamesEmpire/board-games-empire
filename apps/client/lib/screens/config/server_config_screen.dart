import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/server/server_config/server_config_bloc.dart';
import '../../widgets/ui/custom_text_field.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';

class ServerConfigScreenBloc extends StatefulWidget {
  static const routeName = '/server-config';
  final bool isInitialSetup;

  const ServerConfigScreenBloc({super.key, this.isInitialSetup = false});

  @override
  State<ServerConfigScreenBloc> createState() => _ServerConfigScreenBlocState();
}

class _ServerConfigScreenBlocState extends State<ServerConfigScreenBloc> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ServerConfigBloc>().add(
      ServerConfigInitialized(isInitialSetup: widget.isInitialSetup),
    );

    _nameController.addListener(_onNameChanged);
    _urlController.addListener(_onUrlChanged);
  }

  void _onNameChanged() {
    context.read<ServerConfigBloc>().add(
      ServerConfigNameChanged(_nameController.text),
    );
  }

  void _onUrlChanged() {
    context.read<ServerConfigBloc>().add(
      ServerConfigUrlChanged(_urlController.text),
    );
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
              (previous.isAdded != current.isAdded && current.isAdded) ||
              (previous.error != current.error && current.error != null),
      listener: (context, state) {
        if (state.isAdded && state.addedServer != null) {
          if (widget.isInitialSetup) {
            AppRouter.navigateTo(AppRoutes.login);
          } else {
            context.pop(state.addedServer);
          }
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isInitialSetup
                  ? 'Welcome to Board Game Empire'
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
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _urlController,
                labelText: 'Server URL',
                hintText: 'https://my-server.example.com',
                prefixIcon: Icons.link,
                keyboardType: TextInputType.url,
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
                  onPressed:
                      state.isValidating || state.isAdding
                          ? null
                          : _testConnection,
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
                              if (state.isValidated) ...[
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
                      state.isAdding || state.isValidating ? null : _addServer,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state.isAdding
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
                            widget.isInitialSetup
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
      context.read<ServerConfigBloc>().add(
        const ServerConfigValidationRequested(),
      );
    }
  }

  void _addServer() {
    if (_formKey.currentState!.validate()) {
      context.read<ServerConfigBloc>().add(const ServerConfigAddRequested());
    }
  }
}

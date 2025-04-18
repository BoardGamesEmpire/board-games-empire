import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/server_config_service.dart';
import '../../models/config/server_config.dart';
import '../../widgets/ui/custom_text_field.dart';
import '../auth/login_screen.dart';

class ServerConfigScreen extends StatefulWidget {
  static const routeName = '/server-config';
  final bool isInitialSetup;

  const ServerConfigScreen({super.key, this.isInitialSetup = false});

  @override
  State<ServerConfigScreen> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isLoading = false;
  bool _isTestingConnection = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addServer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final configService = Provider.of<ServerConfigService>(
      context,
      listen: false,
    );

    try {
      final newServer = await configService.addServer(
        _nameController.text.trim(),
        _urlController.text.trim(),
      );

      if (widget.isInitialSetup) {
        if (!mounted) return;
        context.replace(LoginScreen.routeName);
      } else {
        if (!mounted) return;
        context.pop(newServer);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _error = null;
    });

    final configService = Provider.of<ServerConfigService>(
      context,
      listen: false,
    );

    try {
      final url = ServerConfig.sanitizeUrl(_urlController.text.trim());
      await configService.validateServer(url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection successful'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isInitialSetup ? 'Welcome to Board Game Empire' : 'Add Server',
        ),
        elevation: 0,
        automaticallyImplyLeading: !widget.isInitialSetup,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
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

                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed:
                            _isTestingConnection || _isLoading
                                ? null
                                : _testConnection,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isTestingConnection
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Test Connection'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading || _isTestingConnection
                                ? null
                                : _addServer,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isLoading
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
          ),
        ),
      ),
    );
  }
}

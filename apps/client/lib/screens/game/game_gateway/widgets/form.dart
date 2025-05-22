import 'package:formz/formz.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/game/game_gateway/game_gateway_bloc.dart';
import '../../../../models/game/game_gateway.dart';
import '../../../../models/game/gateway_inputs.dart';
import '../../../../widgets/ui/form/form_button.dart';

class GatewayForm extends StatefulWidget {
  final bool isEdit;
  final GameGateway? initialGateway;
  final AuthType? initialAuthType;
  final Function(GameGateway) onSubmit;
  final Function(AuthType) onAuthTypeChanged;
  final Function(bool) onFormValidated;

  const GatewayForm({
    super.key,
    required this.isEdit,
    this.initialGateway,
    this.initialAuthType,
    required this.onSubmit,
    required this.onAuthTypeChanged,
    required this.onFormValidated,
  });

  @override
  State<GatewayForm> createState() => _GatewayFormState();
}

class _GatewayFormState extends State<GatewayForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _baseUrlController;
  late TextEditingController _apiVersionController;
  late TextEditingController _apiDocumentationController;
  late TextEditingController _iconUrlController;
  late TextEditingController _logoUrlController;
  late TextEditingController _websiteUrlController;

  late AuthType _authType;

  // Auth parameter controllers based on type
  late TextEditingController _apiKeyNameController;
  late TextEditingController _apiKeyValueController;
  late TextEditingController _basicAuthUsernameController;
  late TextEditingController _basicAuthPasswordController;
  late TextEditingController _oAuthClientIdController;
  late TextEditingController _oAuthClientSecretController;
  late TextEditingController _oAuthRedirectUriController;
  late TextEditingController _pskKeyController;

  bool _enabled = true;

  // Form inputs for validation
  SourceNameInput _nameInput = const SourceNameInput.pure();
  UrlInput _baseUrlInput = const UrlInput.pure();
  UrlInput _apiDocUrlInput = const UrlInput.pure();
  UrlInput _iconUrlInput = const UrlInput.pure();
  UrlInput _logoUrlInput = const UrlInput.pure();
  UrlInput _websiteUrlInput = const UrlInput.pure();
  ApiVersionInput _apiVersionInput = const ApiVersionInput.pure();

  // Auth-specific inputs
  ApiKeyNameInput _apiKeyNameInput = const ApiKeyNameInput.pure();
  ApiKeyValueInput _apiKeyValueInput = const ApiKeyValueInput.pure();
  UsernameInput _basicAuthUsernameInput = const UsernameInput.pure();
  PasswordInput _basicAuthPasswordInput = const PasswordInput.pure();
  ClientIdInput _oAuthClientIdInput = const ClientIdInput.pure();
  ClientSecretInput _oAuthClientSecretInput = const ClientSecretInput.pure();
  UrlInput _oAuthRedirectUriInput = const UrlInput.pure();
  PskInput _pskInput = const PskInput.pure();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    final gateway = widget.initialGateway;

    _nameController = TextEditingController(text: gateway?.name ?? '');
    _descriptionController = TextEditingController(
      text: gateway?.description ?? '',
    );
    _baseUrlController = TextEditingController(text: gateway?.baseUrl ?? '');
    _apiVersionController = TextEditingController(
      text: gateway?.apiVersion ?? '',
    );
    _apiDocumentationController = TextEditingController(
      text: gateway?.apiDocumentation ?? '',
    );
    _iconUrlController = TextEditingController(text: gateway?.iconUrl ?? '');
    _logoUrlController = TextEditingController(text: gateway?.logoUrl ?? '');
    _websiteUrlController = TextEditingController(
      text: gateway?.websiteUrl ?? '',
    );

    _apiKeyNameController = TextEditingController();
    _apiKeyValueController = TextEditingController();
    _basicAuthUsernameController = TextEditingController();
    _basicAuthPasswordController = TextEditingController();
    _oAuthClientIdController = TextEditingController();
    _oAuthClientSecretController = TextEditingController();
    _oAuthRedirectUriController = TextEditingController();
    _pskKeyController = TextEditingController();

    // Use initialAuthType from widget if provided, or fall back to gateway auth type
    _authType = widget.initialAuthType ?? gateway?.authType ?? AuthType.None;
    _enabled = gateway?.enabled ?? true;

    // Load auth parameters if available
    if (gateway != null && gateway.authParameters != null) {
      switch (_authType) {
        case AuthType.ApiKey:
          _apiKeyNameController.text = gateway.authParameters!['name'] ?? '';
          _apiKeyValueController.text = gateway.authParameters!['value'] ?? '';
          break;
        case AuthType.Basic:
          _basicAuthUsernameController.text =
              gateway.authParameters!['username'] ?? '';
          _basicAuthPasswordController.text =
              gateway.authParameters!['password'] ?? '';
          break;
        case AuthType.OAuth:
          _oAuthClientIdController.text =
              gateway.authParameters!['clientId'] ?? '';
          _oAuthClientSecretController.text =
              gateway.authParameters!['clientSecret'] ?? '';
          _oAuthRedirectUriController.text =
              gateway.authParameters!['redirectUri'] ?? '';
          break;
        case AuthType.PSK:
          _pskKeyController.text = gateway.authParameters!['key'] ?? '';
          break;
        case AuthType.None:
          // No parameters needed
          break;
      }
    }

    // Setup input validation
    _nameInput = SourceNameInput.dirty(_nameController.text);
    _baseUrlInput = UrlInput.dirty(_baseUrlController.text);
    _apiDocUrlInput = UrlInput.dirty(_apiDocumentationController.text);
    _iconUrlInput = UrlInput.dirty(_iconUrlController.text);
    _logoUrlInput = UrlInput.dirty(_logoUrlController.text);
    _websiteUrlInput = UrlInput.dirty(_websiteUrlController.text);
    _apiVersionInput = ApiVersionInput.dirty(_apiVersionController.text);

    // Add listeners for all text controllers
    _nameController.addListener(_onNameChanged);
    _baseUrlController.addListener(_onBaseUrlChanged);
    _apiVersionController.addListener(_onApiVersionChanged);
    _apiDocumentationController.addListener(_onApiDocUrlChanged);
    _iconUrlController.addListener(_onIconUrlChanged);
    _logoUrlController.addListener(_onLogoUrlChanged);
    _websiteUrlController.addListener(_onWebsiteUrlChanged);

    _apiKeyNameController.addListener(_onApiKeyNameChanged);
    _apiKeyValueController.addListener(_onApiKeyValueChanged);
    _basicAuthUsernameController.addListener(_onBasicAuthUsernameChanged);
    _basicAuthPasswordController.addListener(_onBasicAuthPasswordChanged);
    _oAuthClientIdController.addListener(_onOAuthClientIdChanged);
    _oAuthClientSecretController.addListener(_onOAuthClientSecretChanged);
    _oAuthRedirectUriController.addListener(_onOAuthRedirectUriChanged);
    _pskKeyController.addListener(_onPskChanged);

    // Validate the form
    _validateForm();
  }

  void _onNameChanged() {
    setState(() {
      _nameInput = SourceNameInput.dirty(_nameController.text);
      _validateForm();
    });
  }

  void _onBaseUrlChanged() {
    setState(() {
      _baseUrlInput = UrlInput.dirty(_baseUrlController.text);
      _validateForm();
    });
  }

  void _onApiVersionChanged() {
    setState(() {
      _apiVersionInput = ApiVersionInput.dirty(_apiVersionController.text);
      _validateForm();
    });
  }

  void _onApiDocUrlChanged() {
    setState(() {
      _apiDocUrlInput = UrlInput.dirty(_apiDocumentationController.text);
      _validateForm();
    });
  }

  void _onIconUrlChanged() {
    setState(() {
      _iconUrlInput = UrlInput.dirty(_iconUrlController.text);
      _validateForm();
    });
  }

  void _onLogoUrlChanged() {
    setState(() {
      _logoUrlInput = UrlInput.dirty(_logoUrlController.text);
      _validateForm();
    });
  }

  void _onWebsiteUrlChanged() {
    setState(() {
      _websiteUrlInput = UrlInput.dirty(_websiteUrlController.text);
      _validateForm();
    });
  }

  void _onApiKeyNameChanged() {
    setState(() {
      _apiKeyNameInput = ApiKeyNameInput.dirty(_apiKeyNameController.text);
      _validateForm();
    });
  }

  void _onApiKeyValueChanged() {
    setState(() {
      _apiKeyValueInput = ApiKeyValueInput.dirty(_apiKeyValueController.text);
      _validateForm();
    });
  }

  void _onBasicAuthUsernameChanged() {
    setState(() {
      _basicAuthUsernameInput = UsernameInput.dirty(
        _basicAuthUsernameController.text,
      );
      _validateForm();
    });
  }

  void _onBasicAuthPasswordChanged() {
    setState(() {
      _basicAuthPasswordInput = PasswordInput.dirty(
        _basicAuthPasswordController.text,
      );
      _validateForm();
    });
  }

  void _onOAuthClientIdChanged() {
    setState(() {
      _oAuthClientIdInput = ClientIdInput.dirty(_oAuthClientIdController.text);
      _validateForm();
    });
  }

  void _onOAuthClientSecretChanged() {
    setState(() {
      _oAuthClientSecretInput = ClientSecretInput.dirty(
        _oAuthClientSecretController.text,
      );
      _validateForm();
    });
  }

  void _onOAuthRedirectUriChanged() {
    setState(() {
      _oAuthRedirectUriInput = UrlInput.dirty(_oAuthRedirectUriController.text);
      _validateForm();
    });
  }

  void _onPskChanged() {
    setState(() {
      _pskInput = PskInput.dirty(_pskKeyController.text);
      _validateForm();
    });
  }

  void _validateForm() {
    final isBasicValid = Formz.validate([
      _nameInput,
      _baseUrlInput,
      _apiVersionInput,
      _apiDocUrlInput,
      _iconUrlInput,
      _logoUrlInput,
      _websiteUrlInput,
    ]);

    // Auth-specific validation
    bool isAuthValid = true;
    switch (_authType) {
      case AuthType.ApiKey:
        isAuthValid = Formz.validate([_apiKeyNameInput, _apiKeyValueInput]);
        break;
      case AuthType.Basic:
        isAuthValid = Formz.validate([
          _basicAuthUsernameInput,
          _basicAuthPasswordInput,
        ]);
        break;
      case AuthType.OAuth:
        isAuthValid = Formz.validate([
          _oAuthClientIdInput,
          _oAuthClientSecretInput,
          _oAuthRedirectUriInput,
        ]);
        break;
      case AuthType.PSK:
        isAuthValid = Formz.validate([_pskInput]);
        break;
      case AuthType.None:
        // No validation needed
        break;
    }

    final isValid = isBasicValid && isAuthValid;

    widget.onFormValidated(isValid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _baseUrlController.dispose();
    _apiVersionController.dispose();
    _apiDocumentationController.dispose();
    _iconUrlController.dispose();
    _logoUrlController.dispose();
    _websiteUrlController.dispose();

    _apiKeyNameController.dispose();
    _apiKeyValueController.dispose();
    _basicAuthUsernameController.dispose();
    _basicAuthPasswordController.dispose();
    _oAuthClientIdController.dispose();
    _oAuthClientSecretController.dispose();
    _oAuthRedirectUriController.dispose();
    _pskKeyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isEdit ? 'Edit Game Gateway' : 'Add New Game Gateway',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Basic Information Section
            _buildSectionTitle(context, 'Basic Information'),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name *',
                hintText: 'Enter a name for this source',
                border: const OutlineInputBorder(),
                errorText: _nameInput.isNotValid ? _nameInput.error : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for this source',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Enable/Disable Switch
            SwitchListTile(
              title: const Text('Enabled'),
              subtitle: const Text('Enable or disable this source'),
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // API Information Section
            _buildSectionTitle(context, 'API Information'),
            const SizedBox(height: 16),

            TextFormField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: 'Base URL',
                hintText: 'https://api.example.com',
                border: const OutlineInputBorder(),
                errorText:
                    _baseUrlInput.isNotValid ? _baseUrlInput.error : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _apiVersionController,
              decoration: InputDecoration(
                labelText: 'API Version',
                hintText: 'e.g., 1.0.0',
                border: const OutlineInputBorder(),
                errorText:
                    _apiVersionInput.isNotValid ? _apiVersionInput.error : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _apiDocumentationController,
              decoration: InputDecoration(
                labelText: 'API Documentation URL',
                hintText: 'https://docs.example.com',
                border: const OutlineInputBorder(),
                errorText:
                    _apiDocUrlInput.isNotValid ? _apiDocUrlInput.error : null,
              ),
            ),

            const SizedBox(height: 24),

            // Visual Information Section
            _buildSectionTitle(context, 'Visual Information'),
            const SizedBox(height: 16),

            TextFormField(
              controller: _iconUrlController,
              decoration: InputDecoration(
                labelText: 'Icon URL',
                hintText: 'https://example.com/icon.png',
                border: const OutlineInputBorder(),
                errorText:
                    _iconUrlInput.isNotValid ? _iconUrlInput.error : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _logoUrlController,
              decoration: InputDecoration(
                labelText: 'Logo URL',
                hintText: 'https://example.com/logo.png',
                border: const OutlineInputBorder(),
                errorText:
                    _logoUrlInput.isNotValid ? _logoUrlInput.error : null,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _websiteUrlController,
              decoration: InputDecoration(
                labelText: 'Website URL',
                hintText: 'https://example.com',
                border: const OutlineInputBorder(),
                errorText:
                    _websiteUrlInput.isNotValid ? _websiteUrlInput.error : null,
              ),
            ),

            const SizedBox(height: 24),

            // Authentication Section
            _buildSectionTitle(
              context,
              'Authentication',
              toolTip:
                  'This is how the source will authenticate with the server',
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<AuthType>(
              value: _authType,
              decoration: const InputDecoration(
                labelText: 'Authentication Type',
                border: OutlineInputBorder(),
              ),
              items:
                  AuthType.values.map((type) {
                    return DropdownMenuItem<AuthType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _authType = value ?? AuthType.None;
                });

                // Notify the parent about auth type change
                widget.onAuthTypeChanged(_authType);

                // Validate form
                _validateForm();
              },
            ),
            const SizedBox(height: 16),

            // Auth-specific fields
            ..._buildAuthFields(),

            const SizedBox(height: 32),

            // The submit button will be enabled/disabled based on bloc state
            BlocBuilder<GameGatewayBloc, GameGatewayState>(
              buildWhen:
                  (previous, current) =>
                      previous.isFormValid != current.isFormValid,
              builder: (context, state) {
                return FormButton(
                  text: widget.isEdit ? 'Update Source' : 'Add Source',
                  onPressed: state.isFormValid ? _submitForm : null,
                  isLoading: state.isOperationInProgress,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAuthFields() {
    switch (_authType) {
      case AuthType.ApiKey:
        return [
          TextFormField(
            controller: _apiKeyNameController,
            decoration: InputDecoration(
              labelText: 'API Key Name *',
              hintText: 'e.g., X-API-Key, Authorization',
              border: const OutlineInputBorder(),
              errorText:
                  _apiKeyNameInput.isNotValid ? _apiKeyNameInput.error : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _apiKeyValueController,
            decoration: InputDecoration(
              labelText: 'API Key Value *',
              hintText: 'Your API key',
              border: const OutlineInputBorder(),
              errorText:
                  _apiKeyValueInput.isNotValid ? _apiKeyValueInput.error : null,
            ),
          ),
        ];

      case AuthType.Basic:
        return [
          TextFormField(
            controller: _basicAuthUsernameController,
            decoration: InputDecoration(
              labelText: 'Username *',
              hintText: 'Enter username',
              border: const OutlineInputBorder(),
              errorText:
                  _basicAuthUsernameInput.isNotValid
                      ? _basicAuthUsernameInput.error
                      : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _basicAuthPasswordController,
            decoration: InputDecoration(
              labelText: 'Password *',
              hintText: 'Enter password',
              border: const OutlineInputBorder(),
              errorText:
                  _basicAuthPasswordInput.isNotValid
                      ? _basicAuthPasswordInput.error
                      : null,
            ),
            obscureText: true,
          ),
        ];

      case AuthType.OAuth:
        return [
          TextFormField(
            controller: _oAuthClientIdController,
            decoration: InputDecoration(
              labelText: 'Client ID *',
              hintText: 'Enter OAuth client ID',
              border: const OutlineInputBorder(),
              errorText:
                  _oAuthClientIdInput.isNotValid
                      ? _oAuthClientIdInput.error
                      : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _oAuthClientSecretController,
            decoration: InputDecoration(
              labelText: 'Client Secret *',
              hintText: 'Enter OAuth client secret',
              border: const OutlineInputBorder(),
              errorText:
                  _oAuthClientSecretInput.isNotValid
                      ? _oAuthClientSecretInput.error
                      : null,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _oAuthRedirectUriController,
            decoration: InputDecoration(
              labelText: 'Redirect URI',
              hintText: 'https://example.com/callback',
              border: const OutlineInputBorder(),
              errorText:
                  _oAuthRedirectUriInput.isNotValid
                      ? _oAuthRedirectUriInput.error
                      : null,
            ),
          ),
        ];

      case AuthType.PSK:
        return [
          TextFormField(
            controller: _pskKeyController,
            decoration: InputDecoration(
              labelText: 'Pre-shared Key *',
              hintText: 'Enter PSK value',
              border: const OutlineInputBorder(),
              errorText: _pskInput.isNotValid ? _pskInput.error : null,
            ),
            obscureText: true,
          ),
        ];

      case AuthType.None:
      default:
        return [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No authentication parameters required.'),
          ),
        ];
    }
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    String? toolTip,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (toolTip != null)
          IconButton(
            icon: const Icon(Icons.info_outline),
            onHover: (isHovered) {
              if (isHovered) {
                // Show tooltip
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(toolTip),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      content: Text(toolTip),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
          ),
        const Divider(),
      ],
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       title,
    //       style: Theme.of(
    //         context,
    //       ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    //     ),
    //     const Divider(),
    //   ],
    // );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic>? authParameters;

      switch (_authType) {
        case AuthType.ApiKey:
          authParameters = {
            'name': _apiKeyNameController.text,
            'value': _apiKeyValueController.text,
          };
          break;
        case AuthType.Basic:
          authParameters = {
            'username': _basicAuthUsernameController.text,
            'password': _basicAuthPasswordController.text,
          };
          break;
        case AuthType.OAuth:
          authParameters = {
            'clientId': _oAuthClientIdController.text,
            'clientSecret': _oAuthClientSecretController.text,
            'redirectUri': _oAuthRedirectUriController.text,
          };
          break;
        case AuthType.PSK:
          authParameters = {'key': _pskKeyController.text};
          break;
        case AuthType.None:
          authParameters = null;
          break;
      }

      final gateway = GameGateway(
        id: widget.initialGateway?.id ?? null,
        name: _nameController.text,
        description:
            _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
        baseUrl:
            _baseUrlController.text.isNotEmpty ? _baseUrlController.text : null,
        apiVersion:
            _apiVersionController.text.isNotEmpty
                ? _apiVersionController.text
                : null,
        apiDocumentation:
            _apiDocumentationController.text.isNotEmpty
                ? _apiDocumentationController.text
                : null,
        iconUrl:
            _iconUrlController.text.isNotEmpty ? _iconUrlController.text : null,
        logoUrl:
            _logoUrlController.text.isNotEmpty ? _logoUrlController.text : null,
        websiteUrl:
            _websiteUrlController.text.isNotEmpty
                ? _websiteUrlController.text
                : null,
        enabled: _enabled,
        authType: _authType != AuthType.None ? _authType : null,
        authParameters: authParameters,
        usageCount: widget.initialGateway?.usageCount ?? 0,
        lastUsed: widget.initialGateway?.lastUsed,
        createdById: widget.initialGateway?.createdById,
        createdAt: widget.initialGateway?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSubmit(gateway);
    }
  }
}

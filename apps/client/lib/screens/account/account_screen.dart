import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/account/account_bloc.dart';
import '../../widgets/ui/custom_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    context.read<AccountBloc>().add(const AccountInitialized());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    final state = context.read<AccountBloc>().state;
    if (state.user != null) {
      _usernameController.text = state.username.value;
      _emailController.text = state.email.value;
      _firstNameController.text = state.firstName.value;
      _lastNameController.text = state.lastName.value;
    }

    _usernameController.addListener(_onUsernameChanged);
    _emailController.addListener(_onEmailChanged);
    _firstNameController.addListener(_onNameChanged);
    _lastNameController.addListener(_onNameChanged);

    _currentPasswordController.addListener(_onCurrentPasswordChanged);
    _newPasswordController.addListener(_onNewPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  void _onUsernameChanged() {
    context.read<AccountBloc>().add(
      AccountUsernameChanged(_usernameController.text),
    );
  }

  void _onEmailChanged() {
    context.read<AccountBloc>().add(AccountEmailChanged(_emailController.text));
  }

  void _onNameChanged() {
    context.read<AccountBloc>().add(
      AccountNameChanged(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
    );
  }

  void _onCurrentPasswordChanged() {
    context.read<AccountBloc>().add(
      AccountCurrentPasswordChanged(_currentPasswordController.text),
    );
  }

  void _onNewPasswordChanged() {
    context.read<AccountBloc>().add(
      AccountPasswordChanged(_newPasswordController.text),
    );
  }

  void _onConfirmPasswordChanged() {
    // Handle in the bloc to maintain purity
  }

  void _submitProfileForm() {
    if (_profileFormKey.currentState?.validate() ?? false) {
      context.read<AccountBloc>().add(const AccountProfileUpdateRequested());
    }
  }

  void _submitPasswordForm() {
    if (_passwordFormKey.currentState?.validate() ?? false) {
      context.read<AccountBloc>().add(const AccountPasswordChangeRequested());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Profile'), Tab(text: 'Password')],
        ),
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.profileStatus != current.profileStatus ||
                previous.passwordStatus != current.passwordStatus,
        listener: (context, state) {
          if (state.profileStatus.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.profileStatus.isFailure && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.passwordStatus.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password changed successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
          } else if (state.passwordStatus.isFailure &&
              state.passwordError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.passwordError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.error ?? 'Failed to load account data'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<AccountBloc>().add(
                          const AccountInitialized(),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [_buildProfileTab(state), _buildPasswordTab(state)],
          );
        },
      ),
    );
  }

  Widget _buildProfileTab(AccountState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  state.user?.firstName?.substring(0, 1).toUpperCase() ??
                      state.user?.username.substring(0, 1).toUpperCase() ??
                      'U',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 24),

            CustomTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter username',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username cannot be empty';
                }
                if (value.length < 3) {
                  return 'Username must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter email address',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email cannot be empty';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _firstNameController,
              labelText: 'First Name (Optional)',
              hintText: 'Enter first name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _lastNameController,
              labelText: 'Last Name (Optional)',
              hintText: 'Enter last name',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed:
                    state.profileStatus.isInProgress
                        ? null
                        : _submitProfileForm,
                child:
                    state.profileStatus.isInProgress
                        ? const CircularProgressIndicator()
                        : const Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTab(AccountState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            CustomTextField(
              controller: _currentPasswordController,
              labelText: 'Current Password',
              hintText: 'Enter current password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureCurrentPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _newPasswordController,
              labelText: 'New Password',
              hintText: 'Enter new password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureNewPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Confirm new password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed:
                    state.passwordStatus.isInProgress
                        ? null
                        : _submitPasswordForm,
                child:
                    state.passwordStatus.isInProgress
                        ? const CircularProgressIndicator()
                        : const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

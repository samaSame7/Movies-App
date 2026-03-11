import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../models/auth_models.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final int _selectedAvatarId = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
          title: const Text('Register', style: TextStyle(color: AppColors.primary)),
          centerTitle: true
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CircleAvatar(radius: 50, backgroundColor: AppColors.fieldFill, child: Icon(Icons.person, size: 60, color: AppColors.textHint)),
                const SizedBox(height: 8),
                const Text('Avatar', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textLight)),
                const SizedBox(height: 32),

                CustomTextField(controller: _nameController, hintText: 'Name', prefixIcon: Icons.badge_outlined),
                CustomTextField(controller: _emailController, hintText: 'Email', prefixIcon: Icons.email_outlined),
                CustomTextField(controller: _passwordController, hintText: 'Password', prefixIcon: Icons.lock_outline, isPassword: true),
                CustomTextField(controller: _confirmController, hintText: 'Confirm Password', prefixIcon: Icons.lock_outline, isPassword: true),
                CustomTextField(controller: _phoneController, hintText: 'Phone Number', prefixIcon: Icons.phone_outlined),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: state is AuthLoading ? null : () {
                    final request = RegisterRequest(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      confirmPassword: _confirmController.text.trim(),
                      phone: _phoneController.text.trim(),
                      avatarId: _selectedAvatarId,
                    );
                    context.read<AuthBloc>().add(RegisterRequested(request));
                  },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Create Account', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
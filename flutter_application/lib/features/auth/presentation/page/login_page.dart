import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:flutter_application/features/auth/presentation/widget/login_form.dart';
import 'package:flutter_application/core/extensions/build_context_extensions.dart';
import 'package:flutter_application/core/router/routes.dart';
import 'package:flutter_application/dependency_injection.dart';

import '../../../../core/constants/spacings.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _AuthBlocListener(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              switch (state.status) {
                case FormzSubmissionStatus.failure:
                  context.showErrorSnackBarMessage(
                    state.errorMessage ?? 'Failed to sign in. Please try again.',
                  );
                  return;
                case FormzSubmissionStatus.success:
                  context.showSnackBarMessage("Email with login link has been sent.");
                  return;
                default:
                  return;
              }
            },
            child: const _ModernLoginLayout(),
          ),
        ),
      ),
    );
  }
}

class _ModernLoginLayout extends StatelessWidget {
  const _ModernLoginLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side - Login Form
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: const Center(
              child: _LoginFormSection(),
            ),
          ),
        ),
        // Right side - Professional Image
        Expanded(
          flex: 6,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              child: const _DeploymentInfoOverlay(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginFormSection extends StatelessWidget {
  const _LoginFormSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Text(
            'BetterFitAi',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          // Main Title
          Text(
            'Log in to BetterFitAi',
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Your personal trainer on your phone.',
            style: context.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          
          // Login Form
          const LoginForm(),
          
          const SizedBox(height: 24),
          
          // Links
          _buildLinks(context),
        ],
      ),
    );
  }

  Widget _buildLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            // TODO: Implement forgot password
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // TODO: Implement help center
          },
          child: Text(
            'Help Center',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
            children: [
              const TextSpan(text: 'By continuing, you confirm that you have read and understood the '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeploymentInfoOverlay extends StatelessWidget {
  const _DeploymentInfoOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 40,
      top: 40,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Deployment', 'betterfitai-prod'),
            const SizedBox(height: 12),
            _buildInfoRow('Domains', 'app.betterfitai.com'),
            const SizedBox(height: 12),
            _buildInfoRow('Status', 'Ready', isStatus: true),
            const SizedBox(height: 12),
            _buildInfoRow('Source', 'main', isSource: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false, bool isSource = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        if (isStatus) ...[
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        if (isSource) ...[
          const Icon(
            Icons.code_branch,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          value,
          style: TextStyle(
            color: isStatus ? Colors.green[700] : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AuthBlocListener extends StatelessWidget {
  const _AuthBlocListener({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUserAuthenticated) {
          context.go(Routes.home.path);
        }
      },
      child: child,
    );
  }
}

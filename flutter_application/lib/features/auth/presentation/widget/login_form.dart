import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/core/constants/spacings.dart';
import 'package:flutter_application/core/extensions/build_context_extensions.dart';
import 'package:flutter_application/core/widgets/form_wrapper.dart';
import 'package:flutter_application/features/auth/presentation/widget/login_button.dart';
import 'package:flutter_application/features/auth/presentation/widget/login_email_input.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_bloc.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_event.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_state.dart';
import 'package:flutter_application/dependency_injection.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MultiProviderAuthBloc>(),
      child: BlocListener<MultiProviderAuthBloc, MultiProviderAuthState>(
        listener: (context, state) {
          if (state.status == MultiProviderAuthStatus.failure) {
            context.showErrorSnackBarMessage(
              state.errorMessage ?? 'Authentication failed. Please try again.',
            );
          } else if (state.status == MultiProviderAuthStatus.success && state.provider == 'email') {
            context.showSnackBarMessage("Email with login link has been sent.");
          }
        },
        child: FormWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginEmailInput(),
              const SizedBox(height: 16),
              const LoginButton(),
              const SizedBox(height: 16),
              
              // Divider with "or"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              
              // Google Sign In Button
              _buildGoogleSignInButton(context),
              const SizedBox(height: 12),
              
              // Apple Sign In Button (iOS only)
              if (Theme.of(context).platform == TargetPlatform.iOS)
                _buildAppleSignInButton(context),
              if (Theme.of(context).platform == TargetPlatform.iOS)
                const SizedBox(height: 12),
              
              const SizedBox(height: 24),
              
              // Sign up link
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return BlocBuilder<MultiProviderAuthBloc, MultiProviderAuthState>(
      builder: (context, state) {
        final isLoading = state.status == MultiProviderAuthStatus.loading && state.provider == 'google';
        
        return OutlinedButton(
          onPressed: isLoading ? null : () {
            context.read<MultiProviderAuthBloc>().add(
              const MultiProviderAuthGoogleSignInRequested(),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://developers.google.com/identity/images/g-logo.png',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildAppleSignInButton(BuildContext context) {
    return BlocBuilder<MultiProviderAuthBloc, MultiProviderAuthState>(
      builder: (context, state) {
        final isLoading = state.status == MultiProviderAuthStatus.loading && state.provider == 'apple';
        
        return OutlinedButton(
          onPressed: isLoading ? null : () {
            context.read<MultiProviderAuthBloc>().add(
              const MultiProviderAuthAppleSignInRequested(),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.apple,
                      size: 20,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Continue with Apple',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign up here',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

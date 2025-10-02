import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/core/extensions/build_context_extensions.dart';
import 'package:flutter_application/core/widgets/centered_circular_progress_indicator.dart';
import 'package:flutter_application/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_bloc.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_event.dart';
import 'package:flutter_application/features/auth/presentation/bloc/multi_provider_auth/multi_provider_auth_state.dart';
import 'package:formz/formz.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<MultiProviderAuthBloc, MultiProviderAuthState>(
          builder: (context, authState) {
            final isLoading = loginState.status.isInProgress || 
                (authState.status == MultiProviderAuthStatus.loading && authState.provider == 'email');
            
            return isLoading
                ? const CenteredCircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: loginState.isValid
                        ? () {
                            context.closeKeyboard();
                            // Use the new multi-provider auth for email sign-in
                            context.read<MultiProviderAuthBloc>().add(
                              MultiProviderAuthEmailSignInRequested(
                                email: loginState.email.value,
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}

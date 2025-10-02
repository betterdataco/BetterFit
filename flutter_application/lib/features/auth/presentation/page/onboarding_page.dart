import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding/onboarding_bloc.dart';
import '../widgets/onboarding_chat_message.dart';
import '../widgets/onboarding_input_field.dart';
import '../widgets/onboarding_choice_buttons.dart';
import '../widgets/onboarding_smart_input.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/constants/spacings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../dependency_injection.dart';
import '../../domain/models/onboarding_data.dart';
import '../../../user/domain/models/user_profile.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OnboardingBloc>()..add(const OnboardingStarted()),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingSuccess) {
            context.showSnackBarMessage('Profile created successfully!');
            context.go(Routes.home.path);
          } else if (state is OnboardingError) {
            context.showErrorSnackBarMessage(state.message);
          }
        },
        child: const _OnboardingView(),
      ),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const _OnboardingHeader(),
            Expanded(
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state is OnboardingInProgress) {
                    return _OnboardingChatView(data: state.data);
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Let\'s get to know you',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }
}

class _OnboardingChatView extends StatelessWidget {
  const _OnboardingChatView({required this.data});

  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Spacing.s16),
            children: [
              _buildWelcomeMessage(),
              if (data.name != null) _buildNameConfirmation(),
              if (data.inferredData != null && data.smartDefaults != null)
                _buildSmartSuggestions(),
              if (data.inferredData?.confidenceBreakdown != null)
                OnboardingConfidenceBreakdown(
                  confidenceBreakdown: data.inferredData!.confidenceBreakdown,
                ),
              _buildCurrentStepMessage(),
            ],
          ),
        ),
        _buildInputSection(context),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return const OnboardingChatMessage(
      isUser: false,
      message:
          'Hi! I\'m here to help you get started with BetterFit. Let\'s create your personalized fitness plan together. What\'s your name?',
    );
  }

  Widget _buildNameConfirmation() {
    return OnboardingChatMessage(
      isUser: false,
      message:
          'Nice to meet you, ${data.name}! I\'ll help you set up your profile with smart suggestions based on your health data.',
    );
  }

  Widget _buildSmartSuggestions() {
    return const OnboardingChatMessage(
      isUser: false,
      message:
          'I\'ve analyzed your health data and have some smart suggestions for your profile. Take a look below!',
    );
  }

  Widget _buildCurrentStepMessage() {
    switch (data.currentStep) {
      case OnboardingStep.name:
        return const OnboardingChatMessage(
          isUser: false,
          message: 'What\'s your name?',
        );
      case OnboardingStep.basicInfo:
        return const OnboardingChatMessage(
          isUser: false,
          message:
              'Let\'s get your basic information. I can suggest values based on your health data, or you can enter them manually.',
        );
      case OnboardingStep.fitnessLevel:
        return const OnboardingChatMessage(
          isUser: false,
          message: 'How active are you currently?',
        );
      case OnboardingStep.goal:
        return const OnboardingChatMessage(
          isUser: false,
          message: 'What\'s your primary fitness goal?',
        );
      case OnboardingStep.gymAccess:
        return const OnboardingChatMessage(
          isUser: false,
          message:
              'Do you have access to a gym, or do you prefer bodyweight exercises?',
        );
      case OnboardingStep.healthKitPermission:
        return const OnboardingChatMessage(
          isUser: false,
          message:
              'Would you like to connect your health data to get more personalized recommendations?',
        );
      case OnboardingStep.complete:
        return const OnboardingChatMessage(
          isUser: false,
          message: 'Perfect! Let\'s create your profile...',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInputSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: _buildCurrentInput(context),
    );
  }

  Widget _buildCurrentInput(BuildContext context) {
    switch (data.currentStep) {
      case OnboardingStep.name:
        return OnboardingInputField(
          hint: 'Enter your name',
          onSubmitted: (value) {
            context
                .read<OnboardingBloc>()
                .add(OnboardingDataUpdated(name: value));
            context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
          },
        );
      case OnboardingStep.basicInfo:
        return _buildBasicInfoInput(context);
      case OnboardingStep.fitnessLevel:
        return OnboardingChoiceButtons(
          options:
              ActivityLevel.values.map((a) => '${a.emoji} ${a.title}').toList(),
          onSelected: (index) {
            context.read<OnboardingBloc>().add(
                  OnboardingDataUpdated(
                      fitnessLevel: ActivityLevel.values[index].fitnessLevel),
                );
            context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
          },
        );
      case OnboardingStep.goal:
        return OnboardingChoiceButtons(
          options:
              FitnessGoal.values.map((g) => '${g.emoji} ${g.title}').toList(),
          onSelected: (index) {
            context.read<OnboardingBloc>().add(
                  OnboardingDataUpdated(goal: FitnessGoal.values[index]),
                );
            context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
          },
        );
      case OnboardingStep.gymAccess:
        return OnboardingChoiceButtons(
          options: const [
            '🏋️ Yes, I have gym access',
            '🏠 No, I prefer bodyweight exercises'
          ],
          onSelected: (index) {
            context.read<OnboardingBloc>().add(
                  OnboardingDataUpdated(gymAccess: index == 0),
                );
            context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
          },
        );
      case OnboardingStep.healthKitPermission:
        return OnboardingChoiceButtons(
          options: const ['📱 Yes, connect my health data', '❌ No, thanks'],
          onSelected: (index) {
            if (index == 0) {
              context
                  .read<OnboardingBloc>()
                  .add(const HealthKitDataRequested());
            }
            context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
          },
        );
      case OnboardingStep.complete:
        return ElevatedButton(
          onPressed: () {
            // Complete onboarding
            context.read<OnboardingBloc>().add(const OnboardingCompleted(
                  userId: 'temp-user-id',
                  email: 'temp@email.com',
                ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Complete Setup'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoInput(BuildContext context) {
    // Show smart suggestions if available
    if (data.inferredData != null && data.smartDefaults != null) {
      return OnboardingSmartInput(
        inferredData: data.inferredData,
        smartDefaults: data.smartDefaults,
        onAccept: () {
          // Accept all smart defaults
          final smartDefaults = data.smartDefaults!;
          context.read<OnboardingBloc>().add(
                OnboardingDataUpdated(
                  age: smartDefaults.suggestedAge,
                  heightCm: smartDefaults.suggestedHeight,
                  weightKg: smartDefaults.suggestedWeight,
                  fitnessLevel: smartDefaults.suggestedFitnessLevel,
                  goal: smartDefaults.suggestedGoal,
                ),
              );
          context.read<OnboardingBloc>().add(const OnboardingStepCompleted());
        },
        onModify: () {
          // Show manual input options
          _showManualInputDialog(context);
        },
      );
    }

    // Fallback to manual input
    return Column(
      children: [
        OnboardingInputField(
          hint: 'Enter your age',
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            final age = int.tryParse(value);
            if (age != null && age > 0) {
              context
                  .read<OnboardingBloc>()
                  .add(OnboardingDataUpdated(age: age));
            }
          },
        ),
        const SizedBox(height: Spacing.s12),
        OnboardingChoiceButtons(
          options:
              Gender.values.map((g) => g.name.replaceAll('_', ' ')).toList(),
          onSelected: (index) {
            context.read<OnboardingBloc>().add(
                  OnboardingDataUpdated(gender: Gender.values[index]),
                );
          },
        ),
        const SizedBox(height: Spacing.s12),
        OnboardingInputField(
          hint: 'Enter height in cm',
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            final height = int.tryParse(value);
            if (height != null && height > 0) {
              context
                  .read<OnboardingBloc>()
                  .add(OnboardingDataUpdated(heightCm: height));
            }
          },
        ),
        const SizedBox(height: Spacing.s12),
        OnboardingInputField(
          hint: 'Enter weight in kg',
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            final weight = int.tryParse(value);
            if (weight != null && weight > 0) {
              context
                  .read<OnboardingBloc>()
                  .add(OnboardingDataUpdated(weightKg: weight));
              context
                  .read<OnboardingBloc>()
                  .add(const OnboardingStepCompleted());
            }
          },
        ),
      ],
    );
  }

  void _showManualInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Enter Your Information',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingInputField(
              hint: 'Age',
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final age = int.tryParse(value);
                if (age != null && age > 0) {
                  context
                      .read<OnboardingBloc>()
                      .add(OnboardingDataUpdated(age: age));
                }
              },
            ),
            const SizedBox(height: Spacing.s12),
            OnboardingInputField(
              hint: 'Height (cm)',
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final height = int.tryParse(value);
                if (height != null && height > 0) {
                  context
                      .read<OnboardingBloc>()
                      .add(OnboardingDataUpdated(heightCm: height));
                }
              },
            ),
            const SizedBox(height: Spacing.s12),
            OnboardingInputField(
              hint: 'Weight (kg)',
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final weight = int.tryParse(value);
                if (weight != null && weight > 0) {
                  context
                      .read<OnboardingBloc>()
                      .add(OnboardingDataUpdated(weightKg: weight));
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<OnboardingBloc>()
                  .add(const OnboardingStepCompleted());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

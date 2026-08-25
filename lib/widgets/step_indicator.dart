import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final Color? activeColor;
  final Color? inactiveColor;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final active = activeColor ?? colorScheme.primary;
    final inactive = inactiveColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.4);

    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCurrent = index == currentStep;
            final isLast = index == totalSteps - 1;

            return Expanded(
              child: Row(
                children: [
                  _StepCircle(
                    index: index,
                    currentStep: currentStep,
                    activeColor: active,
                    inactiveColor: inactive,
                    isCurrent: isCurrent,
                  ),
                  if (!isLast)
                    Expanded(
                      child: _StepLine(
                        isActive: index < currentStep,
                        activeColor: active,
                        inactiveColor: inactive,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            return Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? active : inactive,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final bool isCurrent;

  const _StepCircle({
    required this.index,
    required this.currentStep,
    required this.activeColor,
    required this.inactiveColor,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final size = isCurrent ? 28.0 : 24.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? activeColor : Colors.transparent,
        border: Border.all(
          color: isCompleted || isCurrent ? activeColor : inactiveColor,
          width: isCurrent ? 3 : 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check_rounded, size: size * 0.5, color: Colors.white)
            : Text(
                '${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: isCurrent ? 12 : 10,
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? activeColor : inactiveColor,
                ),
              ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const _StepLine({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}

class HorizontalStepper extends StatelessWidget {
  final int currentStep;
  final List<String> titles;
  final List<String>? subtitles;
  final Color? activeColor;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.titles,
    this.subtitles,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final active = activeColor ?? colorScheme.primary;

    return Row(
      children: List.generate(titles.length, (index) {
        final isActive = index <= currentStep;
        final isLast = index == titles.length - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index < currentStep ? active : colorScheme.outlineVariant,
                    ),
                  ),
                  _StepDot(
                    index: index,
                    currentStep: currentStep,
                    activeColor: active,
                    inactiveColor: colorScheme.outlineVariant,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    titles[index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (subtitles != null && index < subtitles!.length) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitles![index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;

  const _StepDot({
    required this.index,
    required this.currentStep,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCurrent ? 24 : 20,
      height: isCurrent ? 24 : 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? activeColor : colorScheme.surface,
        border: Border.all(
          color: isCompleted || isCurrent ? activeColor : inactiveColor,
          width: isCurrent ? 3 : 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
          : null,
    );
  }
}
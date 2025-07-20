import 'package:flutter/material.dart';

/// Configuration for a notification button
class NotificationButtonConfig {
  final String label;
  final VoidCallback onPressed;
  const NotificationButtonConfig({
    required this.label,
    required this.onPressed,
  });
}

/// Widget that displays a list of notification buttons
class NotificationButtons extends StatelessWidget {
  final List<NotificationButtonConfig> configs;
  const NotificationButtons({super.key, required this.configs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: configs
          .map(
            (config) => NotificationButton(
              label: config.label,
              onPressed: config.onPressed,
            ),
          )
          .toList(),
    );
  }
}

/// Helper widget for a single notification button
class NotificationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const NotificationButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha:0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha:0.9),
          foregroundColor: Colors.deepPurple.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                label: 'Local Notification',
                onTap: () {
                  Navigator.pushNamed(context, '/localnotification');
                },
              ),
              const SizedBox(height: 20),
              _buildButton(
                context,
                label: 'Firebase Messaging',
                onTap: () {
                  Navigator.pushNamed(context, '/firebaseMsg');
                },
              ),
              const SizedBox(height: 20),
              _buildButton(
                context,
                label: 'Awesome',
                onTap: () {
                  Navigator.pushNamed(context, '/awesome');
                },
              ),
              const SizedBox(height: 20),
              _buildButton(
                context,
                label: 'OneSignal',
                onTap: () {
                  Navigator.pushNamed(context, '/onesignal');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget method for buttons
  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.deepPurple.shade700,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}

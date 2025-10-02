import 'package:flutter/material.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF1F2937), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Nutrition',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFB45309)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Today's Meals",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('2169', style: TextStyle(color: Colors.yellow[500], fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(height: 4),
                  const Text('Avg Calories', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Column(
                children: [
                  Text('85%', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 24)),
                  SizedBox(height: 4),
                  Text('Goal Met', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Column(
                children: [
                  Text('6/7', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 24)),
                  SizedBox(height: 4),
                  Text('Days Tracked', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';

class AiGoalMeter extends StatelessWidget {
  final String goal;
  final String currentReward;
  final String nextReward;
  final double progress;
  final double confidence;

  const AiGoalMeter({
    super.key,
    required this.goal,
    required this.currentReward,
    required this.nextReward,
    required this.progress,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.orange.withOpacity(.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Row(
            children: [

              Icon(
                Icons.psychology,
                color: Colors.orange,
              ),

              SizedBox(width: 8),

              Text(
                "KOTA AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),

          const SizedBox(height: 6),

          Text(
            goal,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Current Reward",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  Text(
                    currentReward,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [

                  const Text(
                    "Confidence",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  Text(
                    "${confidence.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            ],
          ),

          const Divider(
            color: Colors.white12,
            height: 28,
          ),

          Text(
            "Next Reward: $nextReward",
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
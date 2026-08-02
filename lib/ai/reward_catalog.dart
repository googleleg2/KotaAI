import '/models/reward.dart';

class RewardCatalog {
  const RewardCatalog();

  List<Reward> get rewards => const [

        Reward(
          id: "free_fries",
          title: "🍟 FREE Fries",
          description: "Free regular fries",
          value: 18,
        ),

        Reward(
          id: "free_cheese",
          title: "🧀 FREE Cheese",
          description: "Add cheese for free",
          value: 12,
        ),

        Reward(
          id: "free_drink",
          title: "🥤 FREE Drink",
          description: "Receive a soft drink",
          value: 20,
        ),

        Reward(
          id: "free_patty",
          title: "🍔 FREE Burger Patty",
          description: "Free beef patty",
          value: 25,
        ),
      ];
}
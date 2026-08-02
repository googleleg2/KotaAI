import 'models/ai_offer.dart';

class RewardStrategyEngine {
  const RewardStrategyEngine();

  AiOffer choose({
    required double cartTotal,
    required bool isQuietDay,
    required bool isPayday,
    required bool isRainy,
  }) {
    // Quiet day:
    // Encourage more orders with an easy-to-reach reward.
    if (isQuietDay) {
      if (cartTotal >= 70) {
        return const AiOffer(
          type: OfferType.freeFries,
          title: "FREE Fries",
          subtitle: "Thanks for ordering today!",
        );
      }
    }

    // Payday:
    // Encourage bigger baskets.
    if (isPayday) {
      if (cartTotal >= 180) {
        return const AiOffer(
          type: OfferType.freeDrink,
          title: "FREE Drink",
          subtitle: "Payday Special",
        );
      }
    }

    // Rainy weather:
    // Keep delivery customers engaged.
    if (isRainy) {
      if (cartTotal >= 95) {
        return const AiOffer(
          type: OfferType.freeDelivery,
          title: "FREE Delivery",
          subtitle: "Rainy Day Reward",
        );
      }
    }

    // Normal trading day.
    if (cartTotal >= 120) {
      return const AiOffer(
        type: OfferType.percentage,
        title: "10% Discount",
        subtitle: "You've unlocked a discount!",
        discountPercent: 10,
      );
    }

    return const AiOffer(
      type: OfferType.none,
      title: "Keep Building",
      subtitle: "Add more ingredients to unlock rewards.",
    );
  }
}
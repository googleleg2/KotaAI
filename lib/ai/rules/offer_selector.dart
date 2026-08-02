import '../models/ai_offer.dart';

class OfferSelector {
  const OfferSelector();

  AiOffer choose({
    required double revenueScore,
    required bool firstOrder,
    required bool birthdayMonth,
    required bool nearReward,
    required bool slowBusiness,
  }) {

    // Birthday always wins
    if (birthdayMonth) {
      return const AiOffer(
        type: OfferType.freeDrink,
        title: "🎉 Happy Birthday!",
        subtitle: "Enjoy a FREE drink with your burger.",
      );
    }

    // Welcome new customers
    if (firstOrder) {
      return const AiOffer(
        type: OfferType.percentage,
        title: "👋 Welcome!",
        subtitle: "Enjoy 15% OFF your first order.",
        discountPercent: 15,
      );
    }

    // Encourage the next reward
    if (nearReward) {
      return const AiOffer(
        type: OfferType.freeFries,
        title: "🍟 Almost There!",
        subtitle: "Spend a little more to unlock FREE fries.",
      );
    }

    // Business is quiet
    if (slowBusiness && revenueScore < 45) {
      return const AiOffer(
        type: OfferType.percentage,
        title: "🔥 Flash Deal",
        subtitle: "Save 20% for the next 30 minutes.",
        discountPercent: 20,
        notifyUser: true,
      );
    }

    // Customer probably buys anyway
    if (revenueScore > 80) {
      return const AiOffer(
        type: OfferType.loyaltyPoints,
        title: "⭐ Loyalty Bonus",
        subtitle: "Earn double points today.",
        loyaltyPoints: 200,
      );
    }

    // Default
    return const AiOffer(
      type: OfferType.none,
      title: "Today's Best Value",
      subtitle: "Build your burger to unlock rewards.",
    );
  }
}
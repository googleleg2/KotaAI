import 'models/ai_offer.dart';
import 'revenue_score.dart';

class RevenueEngine {

  const RevenueEngine();

  AiOffer calculateOffer(
    RevenueScore score,
  ) {

    if (score.total >= 85) {

      return const AiOffer(
        type: OfferType.none,
        title: "Business is Busy",
        subtitle: "No promotion needed.",
      );
    }

    if (score.total >= 70) {

      return const AiOffer(
        type: OfferType.loyaltyPoints,
        title: "Bonus Loyalty",
        subtitle: "Earn double points today.",
        loyaltyPoints: 200,
      );
    }

    if (score.total >= 55) {

      return const AiOffer(
        type: OfferType.freeFries,
        title: "Free Chips",
        subtitle: "Unlock free chips with this order.",
      );
    }

    if (score.total >= 40) {

      return const AiOffer(
        type: OfferType.percentage,
        title: "Today's Special",
        subtitle: "Save 10%",
        discountPercent: 10,
      );
    }

    return const AiOffer(
      type: OfferType.percentage,
      title: "We Miss You",
      subtitle: "Save 20% today",
      discountPercent: 20,
      notifyUser: true,
    );
  }
}
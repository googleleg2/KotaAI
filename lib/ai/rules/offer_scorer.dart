import '../models/ai_offer.dart';
import '../models/cart_analysis.dart';
import '../models/customer_profile.dart';

class OfferScorer {

  const OfferScorer();

  double score({

    required AiOffer offer,

    required CustomerProfile customer,

    required CartAnalysis cart,

    required double revenueScore,

  }) {

    double score = revenueScore;

    switch (offer.type) {

      case OfferType.none:

        score += 5;

        break;

      case OfferType.loyaltyPoints:

        score += 15;

        break;

      case OfferType.freeFries:

        score += 30;

        break;

      case OfferType.freeDrink:

        score += 25;

        break;

      case OfferType.percentage:

        score +=
            offer.discountPercent * .7;

        break;

      case OfferType.fixedAmount:

        score +=
            offer.discountAmount * .4;

        break;

      case OfferType.freeIngredient:

        score += 22;

        break;

      case OfferType.freeDelivery:

        score += 18;

        break;
    }

    if (customer.firstOrder) {

      score += 12;

    }

    if (cart.total > 120) {

      score += 8;

    }

    return score;

  }

}
import 'models/ai_offer.dart';
import 'models/savings.dart';

class SavingsEngine {
  const SavingsEngine();

  Savings calculate({
    required double subtotal,
    required AiOffer offer,
  }) {
    double discount = 0;

    switch (offer.type) {
      case OfferType.percentage:
        discount =
            subtotal *
            (offer.discountPercent / 100);
        break;

      case OfferType.fixedAmount:
        discount = offer.discountAmount;
        break;

      default:
        discount = 0;
    }

    if (discount > subtotal) {
      discount = subtotal;
    }

    return Savings(
      subtotal: subtotal,
      discount: discount,
      total: subtotal - discount,
    );
  }
}
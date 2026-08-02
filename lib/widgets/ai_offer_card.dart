enum OfferType {
  none,
  percentage,
  fixedAmount,
  freeIngredient,
  freeFries,
  freeDrink,
  freeDelivery,
  loyaltyPoints,
}

class AiOffer {
  final OfferType type;

  final String title;

  final String subtitle;

  final double discountPercent;

  final double discountAmount;

  final String? ingredientReward;

  final int loyaltyPoints;

  final bool notifyUser;

  const AiOffer({
    required this.type,
    required this.title,
    required this.subtitle,
    this.discountPercent = 0,
    this.discountAmount = 0,
    this.ingredientReward,
    this.loyaltyPoints = 0,
    this.notifyUser = false,
  });
}
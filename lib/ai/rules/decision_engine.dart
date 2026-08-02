import '../models/ai_offer.dart';
import '../models/offer_candidate.dart';

class DecisionEngine {

  const DecisionEngine();

  AiOffer decide(
    List<OfferCandidate> offers,
  ) {

    if (offers.isEmpty) {

      return const AiOffer(
        type: OfferType.none,
        title: "No Offer",
        subtitle: "",
      );

    }

    offers.sort(

      (a, b) => b.score.compareTo(a.score),

    );

    return offers.first.offer;

  }

}
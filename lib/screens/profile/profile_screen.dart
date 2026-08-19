import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ai/models/ai_offer.dart';
import '../../ai/models/customer_profile.dart';
import '../../ai/models/cart_analysis.dart';
import '../../ai/revenue_engine.dart';
import '../../ai/revenue_score.dart';
import '../../ai/scoring/cart_score.dart';
import '../../ai/scoring/customer_score.dart';
import '../../ai/scoring/time_score.dart';
import '../../constants/app_colors.dart';
import '../../features/checkout/models/customer_order.dart';
import '../../features/checkout/services/order_service.dart';
import '../../services/customer_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _headerAnimation;
  late final Animation<double> _cardAnimation;

  final CustomerProfileService _profileService =
      CustomerProfileService.instance;

  final OrderService _orderService = const OrderService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _cardAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.2,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    _profileService.ensureProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  User? get user => FirebaseAuth.instance.currentUser;

  // ============================================================
  // USER HELPERS
  // ============================================================

  String _fallbackName(User? firebaseUser) {
    if (firebaseUser?.displayName != null &&
        firebaseUser!.displayName!.trim().isNotEmpty) {
      return firebaseUser.displayName!.trim();
    }

    final email = firebaseUser?.email;

    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'Kota Customer';
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign out?'),
          content: const Text(
            'Are you sure you want to sign out of Kota AI?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('SIGN OUT'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!mounted) {
      return;
    }

    context.go('/login');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final firebaseUser = user;

    if (firebaseUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _profileService.streamProfile(),
          builder: (
            context,
            profileSnapshot,
          ) {
            final profileData =
                profileSnapshot.data?.data() ??
                    <String, dynamic>{};

            final name =
                profileData['displayName'] ??
                    _fallbackName(firebaseUser);

            final email =
                profileData['email'] ??
                    firebaseUser.email ??
                    '';

            final amountSaved = _toDouble(
              profileData['amountSaved'],
            );

            final favourites = _getFavouriteCount(
              profileData['favouriteKotas'],
            );

            return StreamBuilder<CustomerProfile?>(
              stream: _profileService.streamCustomerProfile(),
              builder: (
                context,
                customerSnapshot,
              ) {
                final customer =
                    customerSnapshot.data ??
                        CustomerProfile(
                          id: firebaseUser.uid,
                        );

                final totalOrders =
                    customer.totalOrders;

                final points =
                    customer.loyaltyPoints;

                return StreamBuilder<List<CustomerOrder>>(
                  stream:
                      _orderService.streamCustomerOrders(),
                  builder: (
                    context,
                    orderSnapshot,
                  ) {
                    final orders =
                        orderSnapshot.data ??
                            <CustomerOrder>[];

                    return LayoutBuilder(
                      builder: (
                        context,
                        constraints,
                      ) {
                        final width =
                            constraints.maxWidth > 900
                                ? 900.0
                                : constraints.maxWidth;

                        return Center(
                          child: SizedBox(
                            width: width,
                            child:
                                SingleChildScrollView(
                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                20,
                                10,
                                20,
                                40,
                              ),
                              child: Column(
                                children: [
                                  // =================================================
                                  // HEADER
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _headerAnimation,
                                    child:
                                        _buildHeader(
                                      firebaseUser,
                                      name.toString(),
                                      email.toString(),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================================
                                  // CUSTOMER STATS
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildStats(
                                      totalOrders,
                                      points,
                                      amountSaved,
                                      favourites,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================================
                                  // SMART DISCOUNT
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildSmartDiscount(
                                      customer,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  // =================================================
                                  // ACCOUNT
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildAccountSection(
                                      email.toString(),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================================
                                  // REWARDS
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildRewardsSection(
                                      points,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================================
                                  // ORDERS
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildOrders(
                                      orders,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // =================================================
                                  // SETTINGS
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildSettings(),
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  // =================================================
                                  // SIGN OUT
                                  // =================================================

                                  FadeTransition(
                                    opacity:
                                        _cardAnimation,
                                    child:
                                        _buildSignOut(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FIRESTORE VALUE HELPERS
  // ============================================================

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  int _getFavouriteCount(dynamic value) {
    if (value is List) {
      return value.length;
    }

    return 0;
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    User firebaseUser,
    String name,
    String email,
  ) {
    final verified = firebaseUser.emailVerified;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.95),
            AppColors.primary.withOpacity(0.55),
            Colors.black.withOpacity(0.25),
          ],
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (
              context,
              child,
            ) {
              return Transform.rotate(
                angle:
                    _animationController.value *
                    math.pi *
                    0.04,
                child: child,
              );
            },
            child: CircleAvatar(
              radius: 52,
              backgroundColor:
                  Colors.white.withOpacity(0.15),
              backgroundImage:
                  firebaseUser.photoURL != null
                      ? NetworkImage(
                          firebaseUser.photoURL!,
                        )
                      : null,
              child:
                  firebaseUser.photoURL == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 55,
                        )
                      : null,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Welcome back!',
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⭐',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Gold Member',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                verified
                    ? Icons.verified
                    : Icons.warning_amber,
                size: 17,
                color: verified
                    ? Colors.greenAccent
                    : Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMER STATS
  // ============================================================

  Widget _buildStats(
    int orders,
    int points,
    double saved,
    int favourites,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _stat(
              '$orders',
              'Orders',
              Icons.receipt_long_outlined,
            ),
          ),
          _divider(),
          Expanded(
            child: _stat(
              '$points',
              'Points',
              Icons.stars_outlined,
            ),
          ),
          _divider(),
          Expanded(
            child: _stat(
              'R${saved.toStringAsFixed(0)}',
              'Saved',
              Icons.savings_outlined,
            ),
          ),
          _divider(),
          Expanded(
            child: _stat(
              '$favourites',
              'Favourites',
              Icons.favorite_border,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color:
                Colors.white.withOpacity(0.45),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 45,
      width: 1,
      color: Colors.white.withOpacity(0.08),
    );
  }

  // ============================================================
  // SMART DISCOUNT
  //
  // IMPORTANT:
  // Profile does NOT contain business-level sales data.
  //
  // salesToday and targetSales belong to the Dashboard.
  // The profile only uses customer-specific information,
  // cart context and time context.
  // ============================================================

  Widget _buildSmartDiscount(
    CustomerProfile customer,
  ) {
    final customerScore =
        const CustomerScore().calculate(
      customer,
    );

    const CartAnalysis profileCart =
        CartAnalysis(
      total: 0,
      items: 0,
      containsCombo: false,
      profitMargin: 60,
      amountToNextReward: 90,
    );

    final cartScore =
        const CartScore().calculate(
      profileCart,
    );

    final timeScore =
        const TimeScore().calculate(
      DateTime.now(),
    );

    // Customer loyalty is derived from the
    // customer's REAL loyalty points.
    //
    // This is intentionally capped at 100.
    final loyaltyScore =
        customer.loyaltyPoints <= 0
            ? 0.0
            : math.min(
                100.0,
                customer.loyaltyPoints / 10.0,
              );

    // Profile does not know today's business sales.
    //
    // Therefore we do not invent salesToday or targetSales.
    // The dashboard/revenue layer will provide those values.
    //
    // A neutral sales score is used here only so the
    // customer-facing offer card can still operate.
    const double profileSalesScore = 50.0;

    final revenueScore = RevenueScore(
      salesScore: profileSalesScore,
      customerScore: customerScore,
      cartScore: cartScore,
      timeScore: timeScore,
      loyaltyScore: loyaltyScore,
    );

    final AiOffer offer =
        const RevenueEngine().calculateOffer(
      revenueScore,
    );

    return _buildSmartDiscountCard(
      offer,
    );
  }

  // ============================================================
  // SMART DISCOUNT CARD
  // ============================================================

  Widget _buildSmartDiscountCard(
    AiOffer offer,
  ) {
    final bool hasOffer =
        offer.type != OfferType.none;

    String discountLabel = '';

    Color discountColor =
        Colors.greenAccent;

    IconData offerIcon =
        Icons.auto_awesome;

    switch (offer.type) {
      case OfferType.none:
        discountLabel = 'NO OFFER';
        discountColor = Colors.white54;
        offerIcon = Icons.lock_outline;
        break;

      case OfferType.percentage:
        discountLabel =
            '${offer.discountPercent.toStringAsFixed(0)}% OFF';
        discountColor =
            Colors.greenAccent;
        offerIcon = Icons.percent;
        break;

      case OfferType.fixedAmount:
        discountLabel =
            'R${offer.discountAmount.toStringAsFixed(0)} OFF';
        discountColor =
            Colors.greenAccent;
        offerIcon =
            Icons.savings_outlined;
        break;

      case OfferType.freeIngredient:
        discountLabel = 'FREE ITEM';
        discountColor =
            Colors.orangeAccent;
        offerIcon =
            Icons.fastfood_outlined;
        break;

      case OfferType.freeFries:
        discountLabel =
            'FREE FRIES';
        discountColor =
            Colors.orangeAccent;
        offerIcon =
            Icons.fastfood_outlined;
        break;

      case OfferType.freeDrink:
        discountLabel =
            'FREE DRINK';
        discountColor =
            Colors.lightBlueAccent;
        offerIcon =
            Icons.local_drink_outlined;
        break;

      case OfferType.freeDelivery:
        discountLabel =
            'FREE DELIVERY';
        discountColor =
            Colors.lightBlueAccent;
        offerIcon =
            Icons.delivery_dining;
        break;

      case OfferType.loyaltyPoints:
        discountLabel =
            '+${offer.loyaltyPoints} POINTS';
        discountColor =
            Colors.amberAccent;
        offerIcon =
            Icons.stars_outlined;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: hasOffer
              ? AppColors.primary
                  .withOpacity(0.25)
              : Colors.white
                  .withOpacity(0.08),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            hasOffer
                ? AppColors.primary
                    .withOpacity(0.20)
                : Colors.white
                    .withOpacity(0.04),
            Colors.white
                .withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color: hasOffer
                      ? AppColors.primary
                          .withOpacity(
                          0.15,
                        )
                      : Colors.white
                          .withOpacity(0.05),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  offerIcon,
                  color: hasOffer
                      ? AppColors.primary
                      : Colors.white54,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'Smart Discount',
                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Powered by Kota AI',
                      style: TextStyle(
                        color:
                            Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasOffer)
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color: discountColor
                        .withOpacity(
                      0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      color: discountColor
                          .withOpacity(
                        0.25,
                      ),
                    ),
                  ),
                  child: Text(
                    discountLabel,
                    style: TextStyle(
                      color:
                          discountColor,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            hasOffer
                ? offer.title
                : 'No special offer right now.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasOffer
                ? offer.subtitle
                : 'Kota AI is saving your best offer for the right moment.',
            style: TextStyle(
              color: Colors.white
                  .withOpacity(0.55),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          if (hasOffer &&
              offer.type ==
                  OfferType
                      .freeIngredient &&
              offer.ingredientReward !=
                  null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(13),
              decoration:
                  BoxDecoration(
                color: Colors.black
                    .withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons
                        .add_circle_outline,
                    color:
                        Colors.orangeAccent,
                    size: 19,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Free ${offer.ingredientReward}',
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (hasOffer &&
              offer.type ==
                  OfferType
                      .loyaltyPoints) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(13),
              decoration:
                  BoxDecoration(
                color: Colors.amberAccent
                    .withOpacity(0.07),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_outlined,
                    color:
                        Colors.amberAccent,
                    size: 19,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${offer.loyaltyPoints} loyalty points',
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (hasOffer) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(14),
              decoration:
                  BoxDecoration(
                color: Colors.black
                    .withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primary
                          .withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                    child:
                        const Icon(
                      Icons.bolt,
                      color:
                          AppColors
                              .primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'AI Offer Active',
                          style:
                              TextStyle(
                            color:
                                Colors
                                    .white,
                            fontSize: 12,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Use it on your next Kota',
                          style:
                              TextStyle(
                            color:
                                Colors
                                    .white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color:
                        discountColor,
                    size: 19,
                  ),
                ],
              ),
            ),
          ],
          if (hasOffer) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child:
                  ElevatedButton.icon(
                onPressed: () {
                  context.go(
                    '/builder',
                  );
                },
                icon: const Icon(
                  Icons.lunch_dining,
                  size: 19,
                ),
                label: const Text(
                  'BUILD MY KOTA',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
                style:
                    ElevatedButton
                        .styleFrom(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Center(
            child: Text(
              offer.notifyUser
                  ? 'Kota AI has a personalized offer for you'
                  : 'Offers are personalized by Kota AI',
              style: TextStyle(
                color: Colors.white
                    .withOpacity(0.35),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT
  // ============================================================

  Widget _buildAccountSection(
    String email,
  ) {
    return _section(
      'My Account',
      Icons.person_outline,
      [
        _tile(
          Icons.badge_outlined,
          'Personal Information',
          email,
          () {},
        ),
        _tile(
          Icons.location_on_outlined,
          'Delivery Addresses',
          'Manage saved addresses',
          () {},
        ),
        _tile(
          Icons.credit_card_outlined,
          'Payment Methods',
          'Manage payment options',
          () {},
        ),
        _tile(
          Icons.favorite_border,
          'Favourite Kotas',
          'Your saved Kotas',
          () {},
        ),
      ],
    );
  }

  // ============================================================
  // REWARDS
  // ============================================================

  Widget _buildRewardsSection(
    int points,
  ) {
    return _section(
      'Rewards',
      Icons.card_giftcard_outlined,
      [
        _tile(
          Icons.stars_outlined,
          'Loyalty Points',
          '$points points available',
          () {},
        ),
        _tile(
          Icons.local_offer_outlined,
          'Coupons',
          'Your available discounts',
          () {},
        ),
        _tile(
          Icons.auto_awesome,
          'Smart Discounts',
          'AI-powered offers',
          () {},
        ),
        _tile(
          Icons.people_outline,
          'Refer & Earn',
          'Invite friends and earn rewards',
          () {},
        ),
      ],
    );
  }

  // ============================================================
  // ORDERS
  // ============================================================

  Widget _buildOrders(
    List<CustomerOrder> orders,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Order History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 25,
              ),
              child: Center(
                child: Text(
                  'No orders yet.',
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.45),
                  ),
                ),
              ),
            )
          else
            ...orders.take(5).map(
              (order) {
                return _orderTile(order);
              },
            ),
        ],
      ),
    );
  }

  Widget _orderTile(
    CustomerOrder order,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lunch_dining,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order.orderNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${order.items.length} items • R${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  order.paymentStatus,
                  style: TextStyle(
                    color: order.paymentStatus
                                .toLowerCase() ==
                            'paid'
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/builder');
            },
            child: const Text(
              'REORDER',
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Widget _buildSettings() {
    return _section(
      'Settings',
      Icons.settings_outlined,
      [
        _tile(
          Icons.notifications_none,
          'Notifications',
          'Manage notifications',
          () {},
        ),
        _tile(
          Icons.dark_mode_outlined,
          'Appearance',
          'Theme settings',
          () {},
        ),
        _tile(
          Icons.lock_outline,
          'Privacy',
          'Manage privacy',
          () {},
        ),
        _tile(
          Icons.help_outline,
          'Help & Support',
          'Get help with Kota AI',
          () {},
        ),
        _tile(
          Icons.info_outline,
          'About Kota AI',
          'Version 1.0.0',
          () {
            showAboutDialog(
              context: context,
              applicationName:
                  'Kota AI',
              applicationVersion:
                  '1.0.0',
              applicationIcon:
                  const Icon(
                Icons.fastfood,
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _section(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 9),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // TILE
  // ============================================================

  Widget _tile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(0.05),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white70,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color:
              Colors.white.withOpacity(0.4),
          fontSize: 11,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color:
            Colors.white.withOpacity(0.3),
      ),
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Widget _buildSignOut() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: _signOut,
        icon: const Icon(
          Icons.logout,
        ),
        label: const Text(
          'SIGN OUT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              Colors.redAccent,
          side: BorderSide(
            color: Colors.redAccent
                .withOpacity(0.4),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}
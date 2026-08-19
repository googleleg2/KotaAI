import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../models/business_dashboard_data.dart';
import '../services/business_dashboard_service.dart';

import 'business_orders_screen.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({
    super.key,
  });

  static final BusinessDashboardService _service =
      BusinessDashboardService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Business Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<BusinessDashboardData>(
        stream: _service.streamToday(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildError(
              snapshot.error.toString(),
            );
          }

          final data =
              snapshot.data ??
                  const BusinessDashboardData.empty();

          return LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final width =
                  constraints.maxWidth > 1250
                      ? 1250.0
                      : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: width,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      24,
                      15,
                      24,
                      50,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildWelcome(),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================================
                        // MAIN REVENUE CARD
                        // ==================================================

                        _buildRevenueHero(data),

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================================
                        // BUSINESS STATS
                        // ==================================================

                        _buildStatsGrid(
                          context,
                          data,
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================================
                        // PERFORMANCE
                        // ==================================================

                        _buildSectionHeader(
                          icon: Icons.analytics_outlined,
                          title: 'Business Performance',
                          subtitle:
                              'A quick look at today\'s activity',
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _buildPerformanceRow(
                          data,
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================================
                        // BUSINESS INSIGHTS
                        // ==================================================

                        _buildSectionHeader(
                          icon: Icons.insights_outlined,
                          title: 'Business Insights',
                          subtitle:
                              'Keep track of what matters',
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _buildInsightCard(
                          title:
                              'Sales Performance',
                          subtitle:
                              'Monitor revenue and order activity.',
                          icon:
                              Icons.trending_up_rounded,
                          value:
                              'R${data.revenueToday.toStringAsFixed(2)}',
                          label:
                              'Revenue today',
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _buildInsightCard(
                          title:
                              'Product Performance',
                          subtitle:
                              'Track your Kota sales and ingredients.',
                          icon:
                              Icons.fastfood_rounded,
                          value:
                              '${data.ordersToday}',
                          label:
                              'Orders today',
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _buildInsightCard(
                          title:
                              'Customer Activity',
                          subtitle:
                              'See how many customers are buying today.',
                          icon:
                              Icons.people_alt_rounded,
                          value:
                              '${data.customersToday}',
                          label:
                              'Customers today',
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================================
                        // AI REVENUE ENGINE
                        // ==================================================

                        _buildAiCard(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // WELCOME
  // ============================================================

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning 👋',
          style: TextStyle(
            color:
                Colors.white.withOpacity(0.55),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        const Text(
          'Business Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(
          height: 7,
        ),

        Text(
          'Here is what is happening with your Kota business today.',
          style: TextStyle(
            color:
                Colors.white.withOpacity(0.45),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REVENUE HERO
  // ============================================================

  Widget _buildRevenueHero(
    BusinessDashboardData data,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.25),
            AppColors.primary.withOpacity(0.08),
            Colors.white.withOpacity(0.025),
          ],
        ),
        border: Border.all(
          color:
              AppColors.primary.withOpacity(0.20),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.primary.withOpacity(0.08),
            blurRadius: 30,
            offset:
                const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color:
                  AppColors.primary.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(19),
            ),
            child: Icon(
              Icons.payments_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),

          const SizedBox(
            width: 18,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'REVENUE TODAY',
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.55),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'R${data.revenueToday.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Total revenue generated today',
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.green.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.greenAccent,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS GRID
  // ============================================================

  Widget _buildStatsGrid(
  BuildContext context,
  BusinessDashboardData data,
) {
  final cards = [
    _DashboardStat(
      title: 'Orders Today',
      value: '${data.ordersToday}',
      icon: Icons.receipt_long_rounded,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const BusinessOrdersScreen(),
          ),
        );
      },
    ),

    _DashboardStat(
      title: 'Average Order',
      value:
          'R${data.averageOrderValue.toStringAsFixed(2)}',
      icon: Icons.shopping_bag_rounded,
    ),

    _DashboardStat(
      title: 'Customers Today',
      value: '${data.customersToday}',
      icon: Icons.people_alt_rounded,
    ),

    _DashboardStat(
      title: 'Paid Orders',
      value: '${data.paidOrdersToday}',
      icon: Icons.check_circle_rounded,
    ),

    _DashboardStat(
      title: 'Pending Orders',
      value: '${data.pendingOrdersToday}',
      icon: Icons.pending_actions_rounded,
    ),

    _DashboardStat(
      title: 'Orders Processed',
      value: '${data.ordersToday}',
      icon: Icons.point_of_sale_rounded,
    ),
  ];

  return LayoutBuilder(
    builder: (
      context,
      constraints,
    ) {
      final crossAxisCount =
          constraints.maxWidth >= 1000
              ? 3
              : constraints.maxWidth >= 650
                  ? 2
                  : 1;

      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio:
              crossAxisCount == 1
                  ? 3.2
                  : 1.65,
        ),
        itemBuilder: (
          context,
          index,
        ) {
          return _buildStatCard(
            cards[index],
          );
        },
      );
    },
  );
}

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard(
  _DashboardStat stat,
) {
  final clickable = stat.onTap != null;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: stat.onTap,
      borderRadius:
          BorderRadius.circular(23),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(
            clickable ? .065 : .055,
          ),
          borderRadius:
              BorderRadius.circular(23),
          border: Border.all(
            color: clickable
                ? AppColors.primary
                    .withOpacity(.16)
                : Colors.white
                    .withOpacity(.07),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color:
                    AppColors.primary
                        .withOpacity(.13),
                borderRadius:
                    BorderRadius.circular(17),
              ),
              child: Icon(
                stat.icon,
                color:
                    AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    stat.title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          Colors.white
                              .withOpacity(.48),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    stat.value,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
            ),

            if (clickable)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white30,
                size: 15,
              ),
          ],
        ),
      ),
    ),
  );
}

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color:
                AppColors.primary.withOpacity(0.11),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color:
                AppColors.primary,
            size: 22,
          ),
        ),

        const SizedBox(
          width: 13,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                subtitle,
                style: TextStyle(
                  color:
                      Colors.white.withOpacity(0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PERFORMANCE ROW
  // ============================================================

  Widget _buildPerformanceRow(
    BusinessDashboardData data,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final isSmall =
            constraints.maxWidth < 650;

        final children = [
          _buildPerformanceCard(
            icon:
                Icons.receipt_long_rounded,
            title:
                'Orders',
            value:
                '${data.ordersToday}',
            subtitle:
                'today',
          ),

          _buildPerformanceCard(
            icon:
                Icons.people_alt_rounded,
            title:
                'Customers',
            value:
                '${data.customersToday}',
            subtitle:
                'today',
          ),

          _buildPerformanceCard(
            icon:
                Icons.account_balance_wallet_rounded,
            title:
                'Avg. Order',
            value:
                'R${data.averageOrderValue.toStringAsFixed(2)}',
            subtitle:
                'per order',
          ),
        ];

        if (isSmall) {
          return Column(
            children: [
              children[0],
              const SizedBox(height: 12),
              children[1],
              const SizedBox(height: 12),
              children[2],
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: children[0],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: children[1],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: children[2],
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PERFORMANCE CARD
  // ============================================================

  Widget _buildPerformanceCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.04),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.055),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.055),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color:
                  Colors.white70,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  subtitle,
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.3),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INSIGHT CARD
  // ============================================================

  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.035),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.055),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color:
                  AppColors.primary.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color:
                  AppColors.primary,
              size: 25,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  subtitle,
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                label,
                style: TextStyle(
                  color:
                      Colors.white.withOpacity(0.35),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AI REVENUE ENGINE
  // ============================================================

  Widget _buildAiCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.20),
            Colors.white.withOpacity(0.035),
          ],
        ),
        border: Border.all(
          color:
              AppColors.primary.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  AppColors.primary.withOpacity(0.13),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color:
                  AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(
            width: 17,
          ),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Kota AI Revenue Engine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                SizedBox(
                  height: 6,
                ),

                Text(
                  'Smart business intelligence and revenue optimisation will appear here.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.06),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Text(
              'AI',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
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
  // ERROR
  // ============================================================

  Widget _buildError(
    String error,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color:
                    Colors.redAccent.withOpacity(0.10),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color:
                    Colors.redAccent,
                size: 35,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'Unable to load dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              error,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.45),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD STAT MODEL
// ============================================================

class _DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });
}
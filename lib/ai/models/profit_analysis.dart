class ProfitAnalysis {

  final double revenue;

  final double foodCost;

  final double labourCost;

  const ProfitAnalysis({

    required this.revenue,

    required this.foodCost,

    required this.labourCost,
  });

  double get profit =>

      revenue -
      foodCost -
      labourCost;

  double get margin {

    if (revenue == 0) {

      return 0;

    }

    return profit / revenue;

  }

}
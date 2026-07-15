import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../features/builder/background/animated_background.dart';
import '../../features/builder/controllers/kota_scene_controller.dart';
import '../../features/builder/widgets/drop_bread.dart';
import '../../features/builder/widgets/floating_checkout.dart';
import '../../features/builder/widgets/ingredient_tray.dart';
import '../../widgets/animated_price.dart';
// import '../controllers/cart_controller.dart';
import '../../controllers/menu_controller.dart';
// import '../features/builder/background/animated_background.dart';
// import '../features/builder/controllers/kota_scene_controller.dart';
// import '../features/builder/widgets/drop_bread.dart';
// import '../features/builder/widgets/floating_checkout.dart';
// import '../features/builder/widgets/ingredient_tray.dart';
// import '../widgets/animated_price.dart';
import '../../features/builder/widgets/builder_canvas.dart';

class BuilderScreen extends StatelessWidget {
  const BuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cart =
        Provider.of<CartController>(
          context,
          listen: false,
        );

    return ChangeNotifierProvider(

      create: (_) => KotaSceneController(
        cartController: cart,
      ),

      child: Consumer<MenusController>(
        builder: (_, menu, __) {

          return Scaffold(

            backgroundColor: Colors.transparent,

            body: AnimatedBackground(

              child: SafeArea(

                child: Column(

                  children: [

                    const SizedBox(height: 20),

                    const AnimatedPrice(),

                    const SizedBox(height: 20),

                    const Expanded(

                      flex: 6,

                      child: Center(
                        child: BuilderCanvas(),
                      ),
                    ),

                    Expanded(

                      flex: 2,

                      child: IngredientTray(
                        ingredients: menu.menu,
                      ),
                    ),

                    FloatingCheckout(

                      onPressed: () {

                        /// checkout later

                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
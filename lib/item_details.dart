import 'package:capibara/shop_servide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemDetails extends HookWidget {
  const ItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final pageController = usePageController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Capy lamp'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ItemBackground(pageController: pageController),
          Positioned(
            top: mediaQuery.padding.top + kToolbarHeight + 16,
            child: ItemBackgroundImage(
              pageController: pageController,
              size: size,
            ),
          ),
          PageView.builder(
            controller: pageController,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: mediaQuery.padding.top + kToolbarHeight),
                  Image.asset(images[index], height: size.height / 1.59),
                ],
              );
            },
          ),
          Positioned(
            bottom: 16,
            child: ItemDetailsCard(pageController: pageController, size: size),
          ),
        ],
      ),
    );
  }
}

class ItemBackground extends HookWidget {
  final PageController pageController;
  const ItemBackground({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    useListenable(pageController);

    double page = 0.0;
    if (pageController.hasClients &&
        pageController.position.hasContentDimensions) {
      page = pageController.page ?? 0.0;
    }

    final index = page.floor();
    final percent = page - index;

    final currentColor = colors[index.clamp(0, colors.length - 1)];
    final nextColor = colors[(index + 1).clamp(0, colors.length - 1)];

    final color = Color.lerp(currentColor, nextColor, percent);

    return Container(color: color);
  }
}

class ItemBackgroundImage extends HookWidget {
  final PageController pageController;
  final Size size;
  const ItemBackgroundImage({
    super.key,
    required this.pageController,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(pageController);

    double page = 0.0;
    if (pageController.hasClients &&
        pageController.position.hasContentDimensions) {
      page = pageController.page ?? 0.0;
    }

    final alignment = 1.0 - (page / (colors.length - 1)) * 2;

    return Container(
      height: size.height / 2,
      width: size.width - 32,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bedroom.webp'),
          fit: BoxFit.fitHeight,
          alignment: Alignment(alignment, 0),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class ItemDetailsCard extends HookWidget {
  final PageController pageController;
  final Size size;
  const ItemDetailsCard({
    super.key,
    required this.pageController,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    useListenable(pageController);
    double page = 0.0;
    if (pageController.hasClients &&
        pageController.position.hasContentDimensions) {
      page = pageController.page ?? 0.0;
    }

    return Container(
      height: size.height / 4,
      width: size.width - 32,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Choose your\nfavorite color',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Arial',
                    height: 1.0,
                    letterSpacing: -1.0,
                    color: Colors.black,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                label: const Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 12, letterSpacing: -1.0),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  maximumSize: const Size(double.infinity, 35),
                  minimumSize: const Size(50, 35),
                ),
              ),
            ],
          ),
          const Text(
            'Find the perfect color to brighten your space.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Arial',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(colors2.length, (index) {
              final double distance = (page - index).abs();
              final double selectionValue = (1.0 - distance).clamp(0.0, 1.0);

              final double opacity = selectionValue;

              return GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner color circle
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: colors2[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Animated border ring
                      Transform.scale(
                        scale: selectionValue, // Scales from 0 to 1
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors2[index],
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

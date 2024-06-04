import 'package:flutter/material.dart';
import 'package:forky_app_provider/components/card_dishe.dart';
import 'package:forky_app_provider/components/dots_loadings.dart';
import 'package:forky_app_provider/providers/dishe_proivider.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DisheProvider>(context);
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        setState(() {});
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title:
              Text('Pratos', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Consumer<DisheProvider>(builder: (context, value, child) {
                  if (value.isLoading) {
                    return const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [LoadingDots(title: 'Carregando pratos...')],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: provider.dishesFavorites.length,
                        itemBuilder: (context, index) {
                          var dishe = provider.dishesFavorites[index];
                          return GestureDetector(
                            onDoubleTap: () =>
                                provider.removeFavoriteDishe(dishe),
                            child: CardDishe(
                              publisher: dishe.publisher,
                              title: dishe.title,
                              sourceUrl: dishe.sourceUrl,
                              recipeId: dishe.recipeId,
                              imageUrl: dishe.imageUrl,
                              isFavorite: dishe.isFavorite,
                            ),
                          );
                        }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

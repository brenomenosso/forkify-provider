import 'package:flutter/material.dart';
import 'package:forky_app_provider/components/card_dishe.dart';
import 'package:forky_app_provider/components/dots_loadings.dart';
import 'package:forky_app_provider/components/food_selected_list.dart';
import 'package:forky_app_provider/components/list_empity.dart';
import 'package:forky_app_provider/database/localstorage_database.dart';
import 'package:forky_app_provider/modules/favorites/favorite_page.dart';
import 'package:forky_app_provider/providers/dishe_proivider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchFoodEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDishes();
  }

  @override
  void dispose() {
    _searchFoodEC.dispose();
    super.dispose();
  }

  void getDishes() async {
    final provider = context.read<DisheProvider>();
    var lastDishes = await LocalStorageDatabase().getKey('lastDishe');
    if (lastDishes != null) {
      provider.getDishesLocalStorage();
    }
    _searchFoodEC.text = 'Clique para selecionar o nome do prato';
  }

  Future _getFood() async {
    final provider = context.read<DisheProvider>();
    String? food = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FoodSelectedList(),
        ));
    if (food != null) {
      _searchFoodEC.text = food;
      provider.getDishes(food);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DisheProvider>(context);
    return Scaffold(
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
              TextFormField(
                controller: _searchFoodEC,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () => _getFood(),
              ),
              const SizedBox(height: 10),
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
                if (value.dishes.isEmpty) {
                  return const Expanded(
                    child: Center(child: ListEmpityCard()),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: value.dishes.length,
                    itemBuilder: (context, index) {
                      var dishe = value.dishes[index];
                      return GestureDetector(
                        onDoubleTap: () => value.setFavoriteDishe(dishe),
                        child: CardDishe(
                          publisher: dishe.publisher,
                          title: dishe.title,
                          sourceUrl: dishe.sourceUrl,
                          recipeId: dishe.recipeId,
                          imageUrl: dishe.imageUrl,
                          isFavorite: dishe.isFavorite,
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritePage(),
              ));
          await provider.getAllDishes(true);
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  PokemonCard({required this.pokemonUrl, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(PokemonDataProvider(pokemonUrl));
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    return pokemon.when(data: (data) {
      return _card(context, false, data!);
    }, error: (error, stackTrace) {
      return Text("Error $error");
    }, loading: () {
      return _card(context, true, null);
    });
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.30,
        height: MediaQuery.sizeOf(context).height * 0.35,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
          vertical: MediaQuery.sizeOf(context).height * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
          vertical: MediaQuery.sizeOf(context).height * 0.01,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.name?.toUpperCase() ?? "Pokemon",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "# ${pokemon?.id?.toString()}" ?? "Pokemon",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: CircleAvatar(
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon.sprites!.frontDefault!)
                      : null,
                radius: MediaQuery.sizeOf(context).height * 0.05,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                Text(
                  "${pokemon?.moves?.length} moves" ?? "0 moves",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(onPressed: () {
                  _favouritePokemonsProvider.removeFavouritePokemon(pokemonUrl);
                }, icon: Icon(Icons.favorite, color: Colors.red,))
              ],
            )
          ],
        ),
      ),
    );
  }
}

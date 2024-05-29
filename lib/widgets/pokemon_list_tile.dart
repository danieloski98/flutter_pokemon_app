import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning/models/pokemon.dart';
import 'package:learning/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;
  PokemonListTile({required this.pokemonUrl, key});
  @override
  Widget build(BuildContext context, ref) {
    _favouritePokemonsProvider = ref.watch(favouritePokemonsProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonsProvider);
    final pokemon = ref.watch(
      PokemonDataProvider(pokemonUrl),
    );
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Center(
        child: Text('Error $error'),
      );
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon!.sprites!.frontDefault!),
              )
            : CircleAvatar(),
        title: Text(pokemon != null
            ? pokemon.name!.toUpperCase()
            : "Currently loading title"),
        subtitle: Text(
            "Has ${pokemon?.moves?.length.toString() ?? 0.toString()} moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favouritePokemons.contains(pokemonUrl)) {
              _favouritePokemonsProvider.removeFavouritePokemon(pokemonUrl);
            } else {
              _favouritePokemonsProvider.addFavouritePokemon(pokemonUrl);
            }
          },
          icon:  Icon(
             _favouritePokemons.contains(pokemonUrl) ? Icons.favorite : Icons.favorite_border,
            color: _favouritePokemons.contains(pokemonUrl) ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}

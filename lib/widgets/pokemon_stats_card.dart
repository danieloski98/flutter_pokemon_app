import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;
  PokemonStatsCard({ required this.pokemonUrl });
  @override
  Widget build(BuildContext context, ref) {
    final pokemon = ref.watch(PokemonDataProvider(pokemonUrl));
    return AlertDialog(
      title: const Text("Statistics"),
      content: pokemon.when(data: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data?.stats?.map((item) {
            return Text("${item.stat?.name?.toUpperCase()} -> ${item.baseStat}");
          }).toList() ?? [],
        );
      }, error: (error, stackTrace) {
        return Text("$error");
      }, loading: () {
        return const CircularProgressIndicator(
          color: Colors.lightGreen,
        );
      }),
    );
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:learning/models/pokemon.dart';
import 'package:learning/services/database_service.dart';
import 'package:learning/services/http_service.dart';

final PokemonDataProvider = FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data);
  }
  return null;
});

final favouritePokemonsProvider = StateNotifierProvider<FavouritePokemonsProvider, List<String>>((ref) {
  return FavouritePokemonsProvider(
    []
  );
});
class FavouritePokemonsProvider extends StateNotifier<List<String>> {
  
  final DatabaseService _databaseService = GetIt.instance.get<DatabaseService>();

  String FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";
  FavouritePokemonsProvider(
      super._state
      ){
    _setUp();
  }

  Future<void> _setUp() async {
    List<String>? result = await _databaseService.getList(FAVOURITE_POKEMON_LIST_KEY);
    if (result != null) {
      state = result;
    } else {
      state = [];
    }
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY , state);
  }

  void removeFavouritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY , state);
  }
}
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning/controllers/home_page_controller.dart';
import 'package:learning/models/page_data.dart';
import 'package:learning/models/pokemon.dart';
import 'package:learning/providers/pokemon_data_providers.dart';
import 'package:learning/widgets/pokemon_card.dart';
import 'package:learning/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favouritePokemon;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 1 &&
        !_scrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemon = ref.watch(favouritePokemonsProvider);
    return Scaffold(
      appBar: null,
      body: _buildUI(context),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonList(context),
              _allPokemonsList(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      // height: MediaQuery.sizeOf(context).height * 0.50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favourites',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favouritePokemon.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: _favouritePokemon.length,
                      itemBuilder: (context, index) {
                        return PokemonCard(
                            pokemonUrl: _favouritePokemon[index]);
                      },
                    ),
                  ),
                if (_favouritePokemon.isEmpty)
                  const Text(
                    "No favourite pokemons yet!",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Pokemons',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white24,
            ),
            height: MediaQuery.sizeOf(context).height * 0.40,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(
                      pokemonUrl: _homePageData.data!.results![index].url!);
                }),
          )
        ],
      ),
    );
  }
}

class PokemonData {}

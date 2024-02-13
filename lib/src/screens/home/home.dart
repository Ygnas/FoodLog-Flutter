import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool refreshListings;
  const HomeScreen({super.key, required this.refreshListings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Listing>>? listings;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final listingProvider = context.read<ListingProvider>();

    Future<void> refreshListings() async {
      setState(() {
        listings = listingProvider.loadListings();
      });
    }

    if (widget.refreshListings) {
      refreshListings();
    }

    listings ??= listingProvider.loadListings();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Food Log'),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {
                userProvider.user.token.isEmpty
                    ? context.push('/login')
                    : userProvider.logout();
                listings = null;
              },
            )
          ],
        ),
        body: userProvider.user.token != ""
            ? Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: listings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return RefreshIndicator(
                            onRefresh: () => refreshListings(),
                            child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key(snapshot.data![index].id),
                                  confirmDismiss: (direction) async {
                                    // context.push('/login');
                                    return false;
                                  },
                                  background: Container(
                                    color: Colors.green,
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.edit, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.delete, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => context.push('/listings',
                                        extra: snapshot.data![index]),
                                    child: Card(
                                      elevation: 0,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: snapshot.data![index].image
                                                      .isNotEmpty
                                                  ? FadeInImage(
                                                      placeholder:
                                                          const AssetImage(
                                                              "assets/food.png"),
                                                      image: NetworkImage(
                                                          snapshot.data![index]
                                                              .image),
                                                      fit: BoxFit.cover,
                                                      width: 80.0,
                                                      height: double.infinity,
                                                    )
                                                  : const SizedBox(
                                                      width: 80,
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 40.0,
                                                      ),
                                                    ),
                                            ),
                                            title: Text(
                                                snapshot.data![index].title),
                                            subtitle: Text(snapshot
                                                .data![index].description),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  BottomAppBar(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.push('/addlisting'),
                    ),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()));
  }
}

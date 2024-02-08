import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Listing>>? listings;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    Future<void> refreshListings() async {
      setState(() {
        listings = getListing();
      });
    }

    listings ??= getListing();

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
            ? FutureBuilder(
                future: listings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RefreshIndicator(
                      onRefresh: () => refreshListings(),
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snapshot.data![index].title),
                              subtitle: Text(snapshot.data![index].description),
                            );
                          }),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
            : const Center(child: CircularProgressIndicator()));
  }
}

import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/bottom_navigation.dart';
import 'package:food_log/src/widgets/like_comment.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  Future<List<Listing>>? listings;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final listingProvider = context.read<ListingProvider>();

    Future<void> refreshListings() async {
      setState(() {
        listings = listingProvider
            .loadAllListings()
            .then((value) => value.where((element) => element.shared).toList());
      });
    }

    listings ??= listingProvider
        .loadAllListings()
        .then((value) => value.where((element) => element.shared).toList());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              userProvider.user.token.isEmpty
                  ? context.push('/login')
                  : context.push('/profile');
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
                      if (snapshot.connectionState == ConnectionState.done ||
                          snapshot.hasData) {
                        return RefreshIndicator(
                          onRefresh: () => refreshListings(),
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => context.push('/listings',
                                    extra: snapshot.data![index]),
                                child: Card(
                                  elevation: 0,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8.0),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: snapshot
                                                  .data![index].image.isNotEmpty
                                              ? FadeInImage(
                                                  placeholder: const AssetImage(
                                                      "assets/food.png"),
                                                  image: NetworkImage(snapshot
                                                      .data![index].image),
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
                                        title:
                                            Text(snapshot.data![index].title),
                                        subtitle: Text(
                                            snapshot.data![index].description),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            LikeComment(
                                              data: snapshot
                                                  .data![index].likes.length,
                                              dataName: '',
                                              icon: Icons
                                                  .thumb_up_off_alt_outlined,
                                              onTap: () async {
                                                setState(() {
                                                  snapshot.data![index].likes
                                                          .contains(userProvider
                                                              .user.email)
                                                      ? snapshot
                                                          .data![index].likes
                                                          .remove(userProvider
                                                              .user.email)
                                                      : snapshot
                                                          .data![index].likes
                                                          .add(userProvider
                                                              .user.email);
                                                });

                                                await likeListing(
                                                    snapshot.data![index].id!,
                                                    snapshot
                                                        .data![index].email!);
                                              },
                                            ),
                                            const SizedBox(width: 16.0),
                                            LikeComment(
                                                data: snapshot.data![index]
                                                    .comments.length,
                                                dataName: 'comments',
                                                icon: Icons
                                                    .mode_comment_outlined),
                                          ],
                                        ),
                                      ),
                                    ],
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
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: const MyNavigation(
        selectedIndex: 3,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/like_commnet.dart';
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
        title: const Text('Food Log'),
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
                              return Dismissible(
                                key: Key(snapshot.data![index].id!),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    await deleteListing(
                                        snapshot.data![index].id!);
                                    refreshListings();
                                    return true;
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    context.push('/updatelisting',
                                        extra: snapshot.data![index]);
                                    return false;
                                  }
                                  return false;
                                },
                                background: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          subtitle: Text(snapshot
                                              .data![index].description),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            LikeComment(
                                              data: snapshot
                                                  .data![index].likes.length,
                                              dataName: '',
                                              icon: Icons
                                                  .thumb_up_off_alt_outlined,
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
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_rounded),
            label: 'Community',
          )
        ],
        onTap: (index) {
          if (index == 1) {
            context.push('/addlisting');
          }
          if (index == 2) {
            context.push('/community');
          }
        },
      ),
    );
  }
}

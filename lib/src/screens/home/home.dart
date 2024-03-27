import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/bottom_navigation.dart';
import 'package:food_log/src/widgets/filter_button.dart';
import 'package:food_log/src/widgets/search_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool refreshListings;
  const HomeScreen({super.key, required this.refreshListings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;
  Future<List<Listing>>? listings;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
  }

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
          FilterButton(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SearchButton(),
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
                selectedDate != null
                    ? InputChip(
                        label: Text(
                            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                        selected: true,
                        onDeleted: () {
                          setState(() {
                            selectedDate = null;
                          });
                        },
                      )
                    : const SizedBox(),
                Expanded(
                  child: FutureBuilder(
                    future: listings,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done ||
                          snapshot.hasData) {
                        List<Listing> filteredListings = snapshot.data!;
                        if (selectedDate != null) {
                          filteredListings = filteredListings.where((listing) {
                            DateTime listingDate =
                                DateTime.parse(listing.createdAt.toString());
                            return listingDate.year == selectedDate!.year &&
                                listingDate.month == selectedDate!.month &&
                                listingDate.day == selectedDate!.day;
                          }).toList();
                        }
                        return RefreshIndicator(
                          onRefresh: () => refreshListings(),
                          child: ListView.builder(
                            itemCount: filteredListings.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(filteredListings[index].id!),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    await deleteListing(
                                        filteredListings[index].id!);
                                    refreshListings();
                                    return true;
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    context.push('/updatelisting',
                                        extra: filteredListings[index]);
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
                                      extra: filteredListings[index]),
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
                                            child: filteredListings[index]
                                                    .image
                                                    .isNotEmpty
                                                ? FadeInImage(
                                                    key: ValueKey(
                                                        filteredListings[index]
                                                            .image),
                                                    placeholder:
                                                        const AssetImage(
                                                            "assets/food.png"),
                                                    image: NetworkImage(
                                                        filteredListings[index]
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
                                              filteredListings[index].title),
                                          subtitle: Text(filteredListings[index]
                                              .description),
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
      bottomNavigationBar: const MyNavigation(selectedIndex: 0),
    );
  }
}

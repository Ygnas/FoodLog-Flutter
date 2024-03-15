import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
      icon: const Icon(Icons.search),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<Listing?> {
  late final List<Listing>? listings;

  CustomSearchDelegate({
    this.listings,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final listings = context.read<ListingProvider>().listings;
    final results = listings
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.description.toLowerCase().contains(query.toLowerCase()) ||
            element.type.name.toLowerCase().contains(query.toLowerCase()) ||
            element.createdAt
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          subtitle: Text(results[index].description),
          onTap: () {
            close(context, results[index]);
            context.push('/listings', extra: results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listings = context.read<ListingProvider>().listings;
    final results = listings
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.description.toLowerCase().contains(query.toLowerCase()) ||
            element.type.name.toLowerCase().contains(query.toLowerCase()) ||
            element.createdAt
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          subtitle: Text(results[index].description),
          onTap: () {
            close(context, results[index]);
            context.push('/listings', extra: results[index]);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listingProvider = context.read<ListingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              _calculateCenter(listingProvider.listings) ?? const LatLng(0, 0),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
              markers: _buildMarkers(context, listingProvider.listings)),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<Marker> _buildMarkers(BuildContext context, List<Listing> listings) {
  List<Marker> markers = [];

  for (var listing in listings) {
    if (listing.location != null) {
      markers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point:
              LatLng(listing.location!.latitude!, listing.location!.longitude!),
          child: GestureDetector(
            onTap: () {
              _showListingsDialog(
                  context,
                  listings,
                  LatLng(listing.location!.latitude!,
                      listing.location!.longitude!));
            },
            child: const Icon(
              Icons.location_pin,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }
  }

  return markers;
}

void _showListingsDialog(
    BuildContext context, List<Listing> allListings, LatLng tappedLocation) {
  List<Listing> nearbyListings = [];

  for (var listing in allListings) {
    if (listing.location != null &&
        listing.location!.latitude == tappedLocation.latitude &&
        listing.location!.longitude == tappedLocation.longitude) {
      nearbyListings.add(listing);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Listings nearby'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var listing in nearbyListings) ...[
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: listing.image.isNotEmpty
                      ? FadeInImage(
                          key: ValueKey(listing.image),
                          placeholder: const AssetImage("assets/food.png"),
                          image: NetworkImage(listing.image),
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
                title: Text(listing.title),
                subtitle: Text(listing.description),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/listings', extra: listing);
                },
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

LatLng? _calculateCenter(List<Listing> listings) {
  if (listings.isEmpty || listings.first.location == null) {
    return null;
  }

  return LatLng(
    listings.first.location!.latitude!,
    listings.first.location!.longitude!,
  );
}

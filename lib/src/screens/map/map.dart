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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Title: ${listing.title}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (listing.image.isNotEmpty) ...[
                          Image.network(listing.image),
                          const SizedBox(height: 8.0),
                        ],
                        Text('Description: ${listing.description}')
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            context.push('/listings', extra: listing);
                          },
                          child: const Text('Visit Listing')),
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

LatLng? _calculateCenter(List<Listing> listings) {
  if (listings.isEmpty || listings.first.location == null) {
    return null;
  }

  return LatLng(
    listings.first.location!.latitude!,
    listings.first.location!.longitude!,
  );
}

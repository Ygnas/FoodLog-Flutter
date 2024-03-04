import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  bool checkedValue = false;
  ListingType selectedType = ListingType.breakfast;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (mounted) {
      setState(() {
        _currentLocation = locationData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Listing'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                controller: titleController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text('Shared:'),
                  Switch(
                    value: checkedValue,
                    onChanged: (value) {
                      setState(() {
                        checkedValue = value;
                      });
                    },
                  ),
                  const Spacer(),
                  const Text('Type:'),
                  DropdownButton<ListingType>(
                    value: selectedType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    items: ListingType.values.map((type) {
                      return DropdownMenuItem<ListingType>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // await _getLocation();
                  if (formKey.currentState!.validate()) {
                    final listing = Listing(
                      title: titleController.text,
                      description: descriptionController.text,
                      shared: checkedValue,
                      type: selectedType,
                      comments: [],
                      likes: [],
                      location: _currentLocation,
                    );
                    final response = await addListing(listing);
                    if (response.statusCode == 200) {
                      if (context.mounted) {
                        context.go('/', extra: true);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add listing'),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Add Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

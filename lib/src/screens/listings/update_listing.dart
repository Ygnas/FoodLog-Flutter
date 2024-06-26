import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:go_router/go_router.dart';

class UpdateListingScreen extends StatefulWidget {
  final Listing listing;
  const UpdateListingScreen({super.key, required this.listing});

  @override
  State<UpdateListingScreen> createState() => _UpdateListingScreenState();
}

class _UpdateListingScreenState extends State<UpdateListingScreen> {
  bool checkedValue = false;
  ListingType selectedType = ListingType.breakfast;

  late CameraDescription firstCamera;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedType = widget.listing.type;
    checkedValue = widget.listing.shared;
    titleController.text = widget.listing.title;
    descriptionController.text = widget.listing.description;

    availableCameras().then((value) => firstCamera = value.first);
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: InteractiveViewer(
                    child: widget.listing.image.isNotEmpty
                        ? FadeInImage(
                            placeholder: const AssetImage("assets/food.png"),
                            image: NetworkImage(listing.image),
                          )
                        : const SizedBox(
                            width: 120,
                            child: Icon(
                              Icons.image,
                              size: 120.0,
                            ),
                          ),
                  ),
                ),
              ),
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
                  await context.push('/takePicture', extra: {
                    'camera': firstCamera,
                    'listingId': widget.listing.id
                  }).then((value) {
                    if (value != null) {
                      listing.image = value.toString().replaceAll('"', "");
                      imageCache.clear();
                    }
                  });
                },
                child: const Text('Upload Picture'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    listing.title = titleController.text;
                    listing.description = descriptionController.text;
                    listing.shared = checkedValue;
                    listing.type = selectedType;
                    final response = await updateListing(listing);
                    if (response.statusCode == 200) {
                      if (context.mounted) {
                        context.go('/', extra: true);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update listing'),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Update Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

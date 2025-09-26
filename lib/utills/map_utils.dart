import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchGoogleMaps(
  BuildContext context,
  String pickupLocation,
  String dropLocation, {
  bool useCurrentLocation = false,
}) async {
  Uri googleMapsUrl;
  try {
    if (useCurrentLocation) {
      // Check and request location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission permanently denied. Please enable it in settings.',
            ),
          ),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use current location as origin and pickupLocation as destination
      final encodedDrop = Uri.encodeComponent(pickupLocation);
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${position.latitude},${position.longitude}'
        '&destination=$encodedDrop'
        '&travelmode=driving',
      );
    } else {
      // Use pickupLocation as origin and dropLocation as destination
      final encodedPickup = Uri.encodeComponent(pickupLocation);
      final encodedDrop = Uri.encodeComponent(dropLocation);
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=$encodedPickup'
        '&destination=$encodedDrop'
        '&travelmode=driving',
      );
    }

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication, // Prefer app over browser
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error opening Google Maps: $e')));
  }
}

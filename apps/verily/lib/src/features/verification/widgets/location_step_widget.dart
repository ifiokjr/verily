import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/verification_flow_provider.dart';

/// Data class to hold parsed location parameters.
@immutable // Using immutable for simple data holder
class LocationParams {
  final double latitude;
  final double longitude;
  final double radius;
  final String? locationName; // Optional name for display

  const LocationParams({
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.locationName,
  });
}

/// Widget to handle the location verification step.
/// Requires location permissions to be granted beforehand.
/// Refactored to use Hooks.
class LocationStepWidget extends HookConsumerWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const LocationStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  /// Parses the location parameters from the input map.
  /// Returns LocationParams on success, throws FormatException on failure.
  LocationParams _parseParameters(Map<String, dynamic> params) {
    try {
      final latParam = params['latitude'];
      final latitude =
          latParam is num
              ? latParam.toDouble()
              : double.tryParse(latParam?.toString() ?? '');

      final lonParam = params['longitude'];
      final longitude =
          lonParam is num
              ? lonParam.toDouble()
              : double.tryParse(lonParam?.toString() ?? '');

      final radParam = params['radius'];
      final radius =
          radParam is num
              ? radParam.toDouble()
              : double.tryParse(radParam?.toString() ?? '');

      if (latitude == null || longitude == null || radius == null) {
        throw const FormatException('Missing or invalid location parameters.');
      }
      if (radius <= 0) {
        throw const FormatException('Radius must be a positive number.');
      }

      // Extract optional location name
      final locationName = params['locationName']?.toString();

      return LocationParams(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        locationName: locationName,
      );
    } on FormatException {
      // Re-throw format exceptions
      rethrow;
    } catch (e) {
      // Wrap other errors in a FormatException
      throw FormatException('Could not read parameters: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Hooks ---
    // Use state hooks to manage widget state.
    final isLoading = useState<bool>(false); // Loading indicator state
    final currentPosition = useState<Position?>(null); // Current location data
    final distance = useState<double?>(null); // Calculated distance
    final errorMessage = useState<String?>(null); // Error messages
    // Use useMemoized to parse parameters only once unless widget.parameters changes.
    // Handles potential parsing errors.
    final parsedParams = useMemoized<LocationParams?>(
      () {
        try {
          return _parseParameters(parameters);
        } catch (e) {
          // If parsing fails, set error message and report failure immediately.
          // Use a post-frame callback to avoid setting state during build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            errorMessage.value = 'Configuration Error: ${e.toString()}';
            notifier.reportStepFailure(errorMessage.value!);
          });
          return null; // Indicate parsing failure
        }
      },
      [parameters],
    ); // Dependency array ensures re-parsing if parameters change

    // --- Effect Hook for Initial Error (if params failed) ---
    // This useEffect handles the case where parsing failed immediately in useMemoized.
    // It ensures the error message is set and failure is reported.
    useEffect(() {
      if (parsedParams == null && errorMessage.value == null) {
        // If parsing failed but error wasn't set via post-frame callback yet
        // (e.g., during hot reload), set a generic error.
        errorMessage.value = 'Configuration Error: Invalid parameters.';
        notifier.reportStepFailure(errorMessage.value!);
      }
      return null; // No cleanup needed
    }, [parsedParams]); // Runs when parsedParams changes

    // --- Location Check Logic ---
    // Function to perform the location check, now using hooks.
    Future<void> checkCurrentLocation() async {
      // Don't proceed if parameters are invalid (already handled)
      if (parsedParams == null) return;

      isLoading.value = true;
      errorMessage.value = null;
      currentPosition.value = null;
      distance.value = null;

      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final calculatedDistance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          parsedParams.latitude,
          parsedParams.longitude,
        );

        // Update state using hooks
        currentPosition.value = position;
        distance.value = calculatedDistance;

        if (calculatedDistance <= parsedParams.radius) {
          notifier.reportStepSuccess({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'distance_meters': calculatedDistance,
            'target_latitude': parsedParams.latitude,
            'target_longitude': parsedParams.longitude,
            'target_radius_meters': parsedParams.radius,
          });
        } else {
          errorMessage.value =
              'You are approximately ${calculatedDistance.toStringAsFixed(1)}m away. \n'
              'Required distance: ${parsedParams.radius.toStringAsFixed(1)}m.';
        }
      } on LocationServiceDisabledException {
        errorMessage.value =
            'Location services are disabled. Please enable them.';
      } on PermissionDeniedException {
        errorMessage.value =
            'Location permission denied. Please grant permission in settings.';
      } catch (e) {
        errorMessage.value = 'Could not get location: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    // --- UI Build ---
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Verify Location',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Instructions/Target Info (only if parameters parsed successfully)
          if (parsedParams != null)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Location',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // Display optional location name if available
                    if (parsedParams.locationName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          parsedParams.locationName!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Be within ${parsedParams.radius.toStringAsFixed(1)} meters of:',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${parsedParams.latitude.toStringAsFixed(5)}, Lon: ${parsedParams.longitude.toStringAsFixed(5)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Status/Distance display
          // Access state using .value
          if (isLoading.value)
            const Center(child: CircularProgressIndicator())
          else if (currentPosition.value != null && distance.value != null)
            Text(
              'Current Distance: ${distance.value?.toStringAsFixed(1)}m',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 12),

          // Error Message Display
          if (errorMessage.value != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                errorMessage.value!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

          const Spacer(), // Push button to the bottom
          // Check Location Button
          ElevatedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Check My Location'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
            // Disable if parameters are invalid or currently loading
            onPressed:
                (parsedParams == null || isLoading.value)
                    ? null
                    : checkCurrentLocation,
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}

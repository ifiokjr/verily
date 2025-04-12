import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the location verification step.
/// Requires location permissions to be granted beforehand.
class LocationStepWidget extends ConsumerStatefulWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const LocationStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  @override
  ConsumerState<LocationStepWidget> createState() => _LocationStepWidgetState();
}

class _LocationStepWidgetState extends ConsumerState<LocationStepWidget> {
  double? _targetLatitude;
  double? _targetLongitude;
  double? _targetRadius;

  bool _isLoading = false;
  Position? _currentPosition;
  double? _distance;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _parseParameters();
  }

  /// Parses the required parameters (latitude, longitude, radius)
  /// from the widget parameters map.
  void _parseParameters() {
    setState(() {
      _errorMessage = null; // Reset error on re-parse
      try {
        // Attempt to parse latitude
        final latParam = widget.parameters['latitude'];
        _targetLatitude =
            latParam is num
                ? latParam.toDouble()
                : double.tryParse(latParam?.toString() ?? '');

        // Attempt to parse longitude
        final lonParam = widget.parameters['longitude'];
        _targetLongitude =
            lonParam is num
                ? lonParam.toDouble()
                : double.tryParse(lonParam?.toString() ?? '');

        // Attempt to parse radius
        final radParam = widget.parameters['radius'];
        _targetRadius =
            radParam is num
                ? radParam.toDouble()
                : double.tryParse(radParam?.toString() ?? '');

        // Validate that all required parameters were successfully parsed
        if (_targetLatitude == null ||
            _targetLongitude == null ||
            _targetRadius == null) {
          throw FormatException('Missing or invalid location parameters.');
        }
        // Ensure radius is positive
        if (_targetRadius! <= 0) {
          throw FormatException('Radius must be a positive number.');
        }
      } on FormatException catch (e) {
        _errorMessage = 'Configuration Error: ${e.message}';
        // Report failure immediately if parameters are invalid
        widget.notifier.reportStepFailure(_errorMessage!);
      } catch (e) {
        _errorMessage = 'Configuration Error: Could not read parameters.';
        widget.notifier.reportStepFailure(
          _errorMessage!,
        ); // Report unexpected errors
      }
    });
  }

  /// Fetches the current location and checks if it's within the target radius.
  Future<void> _checkCurrentLocation() async {
    // Don't proceed if parameters are invalid
    if (_targetLatitude == null ||
        _targetLongitude == null ||
        _targetRadius == null) {
      // Error should have already been set and reported by _parseParameters
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPosition = null;
      _distance = null;
    });

    try {
      // Fetch current position
      // Consider desired accuracy and timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Adjust as needed
        // timeLimit: const Duration(seconds: 10), // Optional timeout
      );

      // Calculate distance
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _targetLatitude!,
        _targetLongitude!,
      );

      setState(() {
        _currentPosition = position;
        _distance = distance;
      });

      // Check if within radius
      if (distance <= _targetRadius!) {
        // Report success with relevant data
        widget.notifier.reportStepSuccess({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'distance_meters': distance,
          'target_latitude': _targetLatitude,
          'target_longitude': _targetLongitude,
          'target_radius_meters': _targetRadius,
        });
      } else {
        // Stay on the screen, update error message to show user is outside radius
        setState(() {
          _errorMessage =
              'You are approximately ${'_distance?.toStringAsFixed(1)'}m away. \n'
              'Required distance: ${'_targetRadius?.toStringAsFixed(1)'}m.';
        });
      }
    } on LocationServiceDisabledException {
      _errorMessage = 'Location services are disabled. Please enable them.';
    } on PermissionDeniedException {
      // This shouldn't normally happen if the flow provider checks first,
      // but handle defensively.
      _errorMessage =
          'Location permission denied. Please grant permission in settings.';
    } catch (e) {
      // Catch other potential errors (timeout, platform errors)
      _errorMessage = 'Could not get location: ${e.toString()}';
    } finally {
      // Ensure loading indicator is turned off
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the main UI for the location step
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

          // Instructions/Target Info (only if parameters are valid)
          if (_targetLatitude != null &&
              _targetLongitude != null &&
              _targetRadius != null)
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
                    const SizedBox(height: 8),
                    Text(
                      'Be within ${'_targetRadius?.toStringAsFixed(1)'} meters of:',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${'_targetLatitude?.toStringAsFixed(5)'}, Lon: ${'_targetLongitude?.toStringAsFixed(5)'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    // Optionally, add a name for the location if provided in params
                    if (widget.parameters.containsKey('locationName'))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Location: ${widget.parameters['locationName']}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Status/Distance display
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_currentPosition != null && _distance != null)
            Text(
              'Current Distance: ${'_distance?.toStringAsFixed(1)'}m',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 12),

          // Error Message Display
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

          const Spacer(), // Push button to the bottom
          // Check Location Button
          // Only enable if parameters are valid and not currently loading
          ElevatedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Check My Location'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed:
                (_targetLatitude == null ||
                        _targetLongitude == null ||
                        _targetRadius == null ||
                        _isLoading)
                    ? null // Disable if params invalid or loading
                    : _checkCurrentLocation,
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}

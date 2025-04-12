import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing predefined locations.
class LocationEndpoint extends Endpoint {
  /// Fetches all available predefined locations.
  ///
  /// Returns a list of [Location] objects.
  Future<List<Location>> getAvailableLocations(Session session) async {
    // TODO: Implement proper error handling
    try {
      // Fetch all locations from the database
      // Assumes a Location model exists with at least 'id' and 'name'
      final locations = await Location.db.find(
        session,
        // Optional: orderBy: (t) => t.name // Order alphabetically if desired
      );
      return locations;
    } catch (e, stackTrace) {
      print('Error fetching locations: $e\n$stackTrace');
      // Consider throwing a more specific exception or returning an empty list
      throw Exception('Failed to fetch locations: $e');
    }
  }

  // TODO: Add methods for creating/updating/deleting locations if needed later
  // Future<Location?> createLocation(Session session, Location location) async { ... }
}

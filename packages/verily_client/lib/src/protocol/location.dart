/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Location implements _i1.SerializableModel {
  Location._({
    this.id,
    required this.latitude,
    required this.longitude,
    this.radiusMeters,
    this.googlePlacesId,
    this.address,
    required this.createdAt,
  });

  factory Location({
    int? id,
    required double latitude,
    required double longitude,
    double? radiusMeters,
    String? googlePlacesId,
    String? address,
    required DateTime createdAt,
  }) = _LocationImpl;

  factory Location.fromJson(Map<String, dynamic> jsonSerialization) {
    return Location(
      id: jsonSerialization['id'] as int?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      radiusMeters: (jsonSerialization['radiusMeters'] as num?)?.toDouble(),
      googlePlacesId: jsonSerialization['googlePlacesId'] as String?,
      address: jsonSerialization['address'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double latitude;

  double longitude;

  double? radiusMeters;

  String? googlePlacesId;

  String? address;

  DateTime createdAt;

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Location copyWith({
    int? id,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? googlePlacesId,
    String? address,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'latitude': latitude,
      'longitude': longitude,
      if (radiusMeters != null) 'radiusMeters': radiusMeters,
      if (googlePlacesId != null) 'googlePlacesId': googlePlacesId,
      if (address != null) 'address': address,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationImpl extends Location {
  _LocationImpl({
    int? id,
    required double latitude,
    required double longitude,
    double? radiusMeters,
    String? googlePlacesId,
    String? address,
    required DateTime createdAt,
  }) : super._(
         id: id,
         latitude: latitude,
         longitude: longitude,
         radiusMeters: radiusMeters,
         googlePlacesId: googlePlacesId,
         address: address,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Location copyWith({
    Object? id = _Undefined,
    double? latitude,
    double? longitude,
    Object? radiusMeters = _Undefined,
    Object? googlePlacesId = _Undefined,
    Object? address = _Undefined,
    DateTime? createdAt,
  }) {
    return Location(
      id: id is int? ? id : this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters is double? ? radiusMeters : this.radiusMeters,
      googlePlacesId:
          googlePlacesId is String? ? googlePlacesId : this.googlePlacesId,
      address: address is String? ? address : this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

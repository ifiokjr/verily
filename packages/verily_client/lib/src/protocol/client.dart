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
import 'dart:async' as _i2;
import 'package:verily_client/src/protocol/action.dart' as _i3;
import 'package:verily_client/src/protocol/action_step.dart' as _i4;
import 'package:verily_client/src/protocol/webhook.dart' as _i5;
import 'package:verily_client/src/protocol/location.dart' as _i6;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i7;
import 'protocol.dart' as _i8;

/// {@category Endpoint}
class EndpointAction extends _i1.EndpointRef {
  EndpointAction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'action';

  /// Creates a new Action.
  /// The action is associated with the currently authenticated user.
  _i2.Future<_i3.Action> createAction({
    required String name,
    required String description,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
  }) =>
      caller.callServerEndpoint<_i3.Action>(
        'action',
        'createAction',
        {
          'name': name,
          'description': description,
          'locationId': locationId,
          'validFrom': validFrom,
          'validUntil': validUntil,
          'maxCompletionTimeSeconds': maxCompletionTimeSeconds,
          'strictOrder': strictOrder,
        },
      );

  /// Retrieves a list of Actions created by the authenticated user.
  _i2.Future<List<_i3.Action>> getMyActions() =>
      caller.callServerEndpoint<List<_i3.Action>>(
        'action',
        'getMyActions',
        {},
      );

  /// Updates an existing Action.
  /// Requires the action object with updated fields.
  /// Verifies ownership before updating.
  _i2.Future<_i3.Action?> updateAction(_i3.Action action) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'updateAction',
        {'action': action},
      );

  /// Soft deletes an Action by its ID.
  /// Verifies ownership before deleting.
  _i2.Future<bool> deleteAction(int actionId) =>
      caller.callServerEndpoint<bool>(
        'action',
        'deleteAction',
        {'actionId': actionId},
      );

  /// Retrieves full details for a single Action, including steps and webhooks.
  /// Verifies ownership.
  _i2.Future<_i3.Action?> getActionDetails(int actionId) =>
      caller.callServerEndpoint<_i3.Action?>(
        'action',
        'getActionDetails',
        {'actionId': actionId},
      );

  /// Adds a new ActionStep to an existing Action.
  /// Verifies ownership of the parent Action.
  _i2.Future<_i4.ActionStep?> addActionStep(_i4.ActionStep actionStep) =>
      caller.callServerEndpoint<_i4.ActionStep?>(
        'action',
        'addActionStep',
        {'actionStep': actionStep},
      );

  /// Updates an existing ActionStep.
  /// Verifies ownership of the parent Action.
  _i2.Future<_i4.ActionStep?> updateActionStep(_i4.ActionStep actionStep) =>
      caller.callServerEndpoint<_i4.ActionStep?>(
        'action',
        'updateActionStep',
        {'actionStep': actionStep},
      );

  /// Deletes an ActionStep by its ID.
  /// Verifies ownership of the parent Action.
  _i2.Future<bool> deleteActionStep(int actionStepId) =>
      caller.callServerEndpoint<bool>(
        'action',
        'deleteActionStep',
        {'actionStepId': actionStepId},
      );

  /// Adds a new Webhook to an existing Action.
  /// Verifies ownership of the parent Action.
  _i2.Future<_i5.Webhook?> addWebhook(_i5.Webhook webhook) =>
      caller.callServerEndpoint<_i5.Webhook?>(
        'action',
        'addWebhook',
        {'webhook': webhook},
      );

  /// Updates an existing Webhook.
  /// Verifies ownership of the parent Action.
  _i2.Future<_i5.Webhook?> updateWebhook(_i5.Webhook webhook) =>
      caller.callServerEndpoint<_i5.Webhook?>(
        'action',
        'updateWebhook',
        {'webhook': webhook},
      );

  /// Deletes a Webhook by its ID.
  /// Verifies ownership of the parent Action.
  _i2.Future<bool> deleteWebhook(int webhookId) =>
      caller.callServerEndpoint<bool>(
        'action',
        'deleteWebhook',
        {'webhookId': webhookId},
      );
}

/// {@category Endpoint}
class EndpointExample extends _i1.EndpointRef {
  EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {'name': name},
      );
}

/// Endpoint for managing predefined locations.
/// {@category Endpoint}
class EndpointLocation extends _i1.EndpointRef {
  EndpointLocation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'location';

  /// Fetches all available predefined locations.
  ///
  /// Returns a list of [Location] objects.
  _i2.Future<List<_i6.Location>> getAvailableLocations() =>
      caller.callServerEndpoint<List<_i6.Location>>(
        'location',
        'getAvailableLocations',
        {},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i7.Caller(client);
  }

  late final _i7.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i8.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    action = EndpointAction(this);
    example = EndpointExample(this);
    location = EndpointLocation(this);
    modules = Modules(this);
  }

  late final EndpointAction action;

  late final EndpointExample example;

  late final EndpointLocation location;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'action': action,
        'example': example,
        'location': location,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}

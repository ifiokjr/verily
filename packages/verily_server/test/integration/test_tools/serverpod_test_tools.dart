/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:verily_server/src/generated/action.dart' as _i4;
import 'package:verily_server/src/generated/action_step.dart' as _i5;
import 'package:verily_server/src/generated/webhook.dart' as _i6;
import 'package:verily_server/src/generated/location.dart' as _i7;
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  bool? enableSessionLogging,
  _i2.ExperimentalFeatures? experimentalFeatures,
  _i1.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      experimentalFeatures: experimentalFeatures,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
  )(testClosure);
}

class TestEndpoints {
  late final _ActionEndpoint action;

  late final _ExampleEndpoint example;

  late final _LocationEndpoint location;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    action = _ActionEndpoint(endpoints, serializationManager);
    example = _ExampleEndpoint(endpoints, serializationManager);
    location = _LocationEndpoint(endpoints, serializationManager);
  }
}

class _ActionEndpoint {
  _ActionEndpoint(this._endpointDispatch, this._serializationManager);

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.Action> createAction(
    _i1.TestSessionBuilder sessionBuilder, {
    required String name,
    required String description,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'createAction');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'createAction',
          parameters: _i1.testObjectToJson({
            'name': name,
            'description': description,
            'locationId': locationId,
            'validFrom': validFrom,
            'validUntil': validUntil,
            'maxCompletionTimeSeconds': maxCompletionTimeSeconds,
            'strictOrder': strictOrder,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.Action>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i4.Action>> getMyActions(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'getMyActions');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'getMyActions',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i4.Action>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.Action?> updateAction(
    _i1.TestSessionBuilder sessionBuilder,
    _i4.Action action,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'updateAction');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'updateAction',
          parameters: _i1.testObjectToJson({'action': action}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.Action?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteAction(
    _i1.TestSessionBuilder sessionBuilder,
    int actionId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'deleteAction');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'deleteAction',
          parameters: _i1.testObjectToJson({'actionId': actionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.Action?> getActionDetails(
    _i1.TestSessionBuilder sessionBuilder,
    int actionId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'getActionDetails');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'getActionDetails',
          parameters: _i1.testObjectToJson({'actionId': actionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.Action?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i5.ActionStep?> addActionStep(
    _i1.TestSessionBuilder sessionBuilder,
    _i5.ActionStep actionStep,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'addActionStep');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'addActionStep',
          parameters: _i1.testObjectToJson({'actionStep': actionStep}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.ActionStep?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i5.ActionStep?> updateActionStep(
    _i1.TestSessionBuilder sessionBuilder,
    _i5.ActionStep actionStep,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'updateActionStep');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'updateActionStep',
          parameters: _i1.testObjectToJson({'actionStep': actionStep}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.ActionStep?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteActionStep(
    _i1.TestSessionBuilder sessionBuilder,
    int actionStepId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'deleteActionStep');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'deleteActionStep',
          parameters: _i1.testObjectToJson({'actionStepId': actionStepId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> reorderActionSteps(
    _i1.TestSessionBuilder sessionBuilder,
    int actionId,
    List<int> orderedStepIds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'reorderActionSteps');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'reorderActionSteps',
          parameters: _i1.testObjectToJson({
            'actionId': actionId,
            'orderedStepIds': orderedStepIds,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.Webhook?> addWebhook(
    _i1.TestSessionBuilder sessionBuilder,
    _i6.Webhook webhook,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'addWebhook');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'addWebhook',
          parameters: _i1.testObjectToJson({'webhook': webhook}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i6.Webhook?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.Webhook?> updateWebhook(
    _i1.TestSessionBuilder sessionBuilder,
    _i6.Webhook webhook,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'updateWebhook');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'updateWebhook',
          parameters: _i1.testObjectToJson({'webhook': webhook}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i6.Webhook?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteWebhook(
    _i1.TestSessionBuilder sessionBuilder,
    int webhookId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'action', method: 'deleteWebhook');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'action',
          methodName: 'deleteWebhook',
          parameters: _i1.testObjectToJson({'webhookId': webhookId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ExampleEndpoint {
  _ExampleEndpoint(this._endpointDispatch, this._serializationManager);

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> hello(
    _i1.TestSessionBuilder sessionBuilder,
    String name,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'example', method: 'hello');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'example',
          methodName: 'hello',
          parameters: _i1.testObjectToJson({'name': name}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _LocationEndpoint {
  _LocationEndpoint(this._endpointDispatch, this._serializationManager);

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i7.Location>> getAvailableLocations(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'location', method: 'getAvailableLocations');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'location',
          methodName: 'getAvailableLocations',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i7.Location>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

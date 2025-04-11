/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/action_endpoint.dart' as _i2;
import '../endpoints/example_endpoint.dart' as _i3;
import 'package:verily_server/src/generated/action.dart' as _i4;
import 'package:verily_server/src/generated/action_step.dart' as _i5;
import 'package:verily_server/src/generated/webhook.dart' as _i6;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i7;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'action': _i2.ActionEndpoint()
        ..initialize(
          server,
          'action',
          null,
        ),
      'example': _i3.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
    };
    connectors['action'] = _i1.EndpointConnector(
      name: 'action',
      endpoint: endpoints['action']!,
      methodConnectors: {
        'createAction': _i1.MethodConnector(
          name: 'createAction',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'locationId': _i1.ParameterDescription(
              name: 'locationId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'validFrom': _i1.ParameterDescription(
              name: 'validFrom',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'validUntil': _i1.ParameterDescription(
              name: 'validUntil',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'maxCompletionTimeSeconds': _i1.ParameterDescription(
              name: 'maxCompletionTimeSeconds',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'strictOrder': _i1.ParameterDescription(
              name: 'strictOrder',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).createAction(
            session,
            name: params['name'],
            description: params['description'],
            locationId: params['locationId'],
            validFrom: params['validFrom'],
            validUntil: params['validUntil'],
            maxCompletionTimeSeconds: params['maxCompletionTimeSeconds'],
            strictOrder: params['strictOrder'],
          ),
        ),
        'getMyActions': _i1.MethodConnector(
          name: 'getMyActions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).getMyActions(session),
        ),
        'updateAction': _i1.MethodConnector(
          name: 'updateAction',
          params: {
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<_i4.Action>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).updateAction(
            session,
            params['action'],
          ),
        ),
        'deleteAction': _i1.MethodConnector(
          name: 'deleteAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).deleteAction(
            session,
            params['actionId'],
          ),
        ),
        'getActionDetails': _i1.MethodConnector(
          name: 'getActionDetails',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).getActionDetails(
            session,
            params['actionId'],
          ),
        ),
        'addActionStep': _i1.MethodConnector(
          name: 'addActionStep',
          params: {
            'actionStep': _i1.ParameterDescription(
              name: 'actionStep',
              type: _i1.getType<_i5.ActionStep>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).addActionStep(
            session,
            params['actionStep'],
          ),
        ),
        'updateActionStep': _i1.MethodConnector(
          name: 'updateActionStep',
          params: {
            'actionStep': _i1.ParameterDescription(
              name: 'actionStep',
              type: _i1.getType<_i5.ActionStep>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).updateActionStep(
            session,
            params['actionStep'],
          ),
        ),
        'deleteActionStep': _i1.MethodConnector(
          name: 'deleteActionStep',
          params: {
            'actionStepId': _i1.ParameterDescription(
              name: 'actionStepId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).deleteActionStep(
            session,
            params['actionStepId'],
          ),
        ),
        'addWebhook': _i1.MethodConnector(
          name: 'addWebhook',
          params: {
            'webhook': _i1.ParameterDescription(
              name: 'webhook',
              type: _i1.getType<_i6.Webhook>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).addWebhook(
            session,
            params['webhook'],
          ),
        ),
        'updateWebhook': _i1.MethodConnector(
          name: 'updateWebhook',
          params: {
            'webhook': _i1.ParameterDescription(
              name: 'webhook',
              type: _i1.getType<_i6.Webhook>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).updateWebhook(
            session,
            params['webhook'],
          ),
        ),
        'deleteWebhook': _i1.MethodConnector(
          name: 'deleteWebhook',
          params: {
            'webhookId': _i1.ParameterDescription(
              name: 'webhookId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['action'] as _i2.ActionEndpoint).deleteWebhook(
            session,
            params['webhookId'],
          ),
        ),
      },
    );
    connectors['example'] = _i1.EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['example'] as _i3.ExampleEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i7.Endpoints()..initializeEndpoints(server);
  }
}

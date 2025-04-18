import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

// An endpoint for managing Action entities.
class ActionEndpoint extends Endpoint {
  /// Requires the user to be authenticated to access any method.
  @override
  bool get requireLogin => true;

  /// Creates a new Action.
  /// The action is associated with the currently authenticated user.
  Future<Action> createAction(
    Session session, {
    required String name,
    required String description,
    int? locationId,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxCompletionTimeSeconds,
    bool? strictOrder,
  }) async {
    // Use the correct pattern from serverpod.mdc rule
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;

    // Add null check for safety, though requireLogin should guarantee it
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // TODO: Optionally validate locationId exists if provided

    // Use the correctly generated Action constructor with userInfoId
    Action newAction = Action(
      userInfoId: userId, // Use the non-nullable userId
      name: name,
      description: description,
      locationId: locationId, // Pass new field
      validFrom: validFrom?.toUtc(), // Pass new field (ensure UTC)
      validUntil: validUntil?.toUtc(), // Pass new field (ensure UTC)
      maxCompletionTimeSeconds: maxCompletionTimeSeconds, // Pass new field
      strictOrder: strictOrder ?? true, // Pass new field with default
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
      steps: null,
      webhooks: null,
    );

    Action createdAction = await Action.db.insertRow(session, newAction);
    session.log(
      'Created Action id: ${createdAction.id} for user $userId',
      level: LogLevel.info,
    );
    return createdAction;

    // Remove placeholder
    // throw UnimplementedError('Needs implementation after serverpod generate');
  }

  /// Retrieves a list of Actions created by the authenticated user.
  Future<List<Action>> getMyActions(Session session) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;

    // Add null check
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Query using the correctly generated userInfoId field
    // Also filter out soft-deleted actions
    List<Action> actions = await Action.db.find(
      session,
      where:
          (action) =>
              action.userInfoId.equals(userId) &
              action.isDeleted.equals(false), // Don't return deleted actions
      orderBy: (action) => action.createdAt,
      orderDescending: true,
    );

    session.log(
      'Fetched ${actions.length} actions for user $userId',
      level: LogLevel.debug,
    );
    return actions;

    // Remove placeholder
    // throw UnimplementedError('Needs implementation after serverpod generate');
  }

  /// Updates an existing Action.
  /// Requires the action object with updated fields.
  /// Verifies ownership before updating.
  Future<Action?> updateAction(Session session, Action action) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;

    // Add null check
    if (userId == null) {
      session.log(
        'Update failed: User not authenticated.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Verify ownership: Check if the action exists and belongs to the user
    Action? existingAction = await Action.db.findById(session, action.id!);
    if (existingAction == null || existingAction.userInfoId != userId) {
      session.log(
        'Update failed: Action ${action.id} not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return null; // Or throw an exception
    }

    // TODO: Optionally validate new locationId exists if provided in action.locationId

    // Update the timestamp and ensure non-updatable fields are preserved
    // Use the incoming 'action' object for updated fields
    Action actionToUpdate = action.copyWith(
      // Fields that should NOT be updated directly via this method
      userInfoId: existingAction.userInfoId, // Preserve original owner
      createdAt: existingAction.createdAt, // Preserve original creation time
      isDeleted: existingAction.isDeleted, // Use deleteAction for this
      // Update timestamp
      updatedAt: DateTime.now().toUtc(),
      // Ensure incoming dates are UTC if provided
      validFrom: action.validFrom?.toUtc(),
      validUntil: action.validUntil?.toUtc(),
      // Note: Updating steps/webhooks might need separate methods
      // All other fields (name, description, locationId, time constraints, strictOrder)
      // are taken from the incoming 'action' object via copyWith.
    );

    // Perform the update
    Action? updatedAction = await Action.db.updateRow(session, actionToUpdate);
    session.log('Updated Action id: ${updatedAction.id}', level: LogLevel.info);
    return updatedAction;
  }

  /// Soft deletes an Action by its ID.
  /// Verifies ownership before deleting.
  Future<bool> deleteAction(Session session, int actionId) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;

    // Add null check
    if (userId == null) {
      session.log(
        'Delete failed: User not authenticated.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Find the action to verify ownership
    Action? actionToDelete = await Action.db.findById(session, actionId);
    if (actionToDelete == null || actionToDelete.userInfoId != userId) {
      session.log(
        'Delete failed: Action $actionId not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return false; // Indicate failure
    }

    // Don't delete if already deleted
    if (actionToDelete.isDeleted) {
      session.log(
        'Delete skipped: Action $actionId already marked as deleted.',
        level: LogLevel.info,
      );
      return true; // Indicate success (idempotent)
    }

    // Perform soft delete
    Action updatedAction = actionToDelete.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().toUtc(),
    );

    // Update the row in the database
    Action? result = await Action.db.updateRow(session, updatedAction);

    bool success = result != null;
    session.log(
      '${success ? 'Deleted' : 'Failed to delete'} Action id: $actionId',
      level: success ? LogLevel.info : LogLevel.error,
    );
    return success;
  }

  /// Retrieves full details for a single Action, including steps and webhooks.
  /// Verifies ownership.
  Future<Action?> getActionDetails(Session session, int actionId) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find the action and verify ownership
    Action? action = await Action.db.findById(
      session,
      actionId,
      // Include related steps and webhooks in the query
      include: Action.include(
        steps: ActionStep.includeList(
          // Also filter out soft-deleted steps if a flag exists
          // where: (step) => step.isDeleted.equals(false),
          orderBy: (step) => step.order,
        ),
        webhooks: Webhook.includeList(
          // where: (hook) => hook.isDeleted.equals(false),
          // orderBy: (hook) => hook.createdAt,
        ),
      ),
    );

    if (action == null || action.userInfoId != userId || action.isDeleted) {
      session.log(
        'Get Details failed: Action $actionId not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Steps are already ordered by the include query
    // action.steps?.sort((a, b) => a.order.compareTo(b.order));

    session.log(
      'Fetched details for Action id: $actionId',
      level: LogLevel.debug,
    );
    return action;
  }

  // --- ActionStep Methods ---

  /// Adds a new ActionStep to an existing Action.
  /// Verifies ownership of the parent Action.
  Future<ActionStep?> addActionStep(
    Session session,
    ActionStep actionStep, // Expects actionStep.actionId to be set
  ) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Verify ownership of the parent Action
    final actionId = actionStep.actionId;
    Action? parentAction = await Action.db.findById(session, actionId);
    if (parentAction == null || parentAction.userInfoId != userId) {
      session.log(
        'Add Step failed: Action $actionId not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return null;
    }

    // TODO: Add validation for actionStep.type and actionStep.parameters

    // Set creation time and ensure isDeleted is false
    ActionStep stepToInsert = actionStep.copyWith(
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      // isDeleted: false, // Assuming ActionStep model has isDeleted field
    );

    ActionStep? createdStep = await ActionStep.db.insertRow(
      session,
      stepToInsert,
    );
    session.log(
      'Added ActionStep id: ${createdStep.id} to Action id: $actionId',
      level: LogLevel.info,
    );
    return createdStep;
  }

  /// Updates an existing ActionStep.
  /// Verifies ownership of the parent Action.
  Future<ActionStep?> updateActionStep(
    Session session,
    ActionStep
    actionStep, // Expects actionStep.id and actionStep.actionId to be set
  ) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find the existing step
    ActionStep? existingStep = await ActionStep.db.findById(
      session,
      actionStep.id!,
    );
    if (existingStep == null) {
      session.log(
        'Update Step failed: Step ${actionStep.id} not found.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Verify ownership of the parent Action using the *existing* step's actionId
    final actionId = existingStep.actionId;
    Action? parentAction = await Action.db.findById(session, actionId);
    if (parentAction == null || parentAction.userInfoId != userId) {
      session.log(
        'Update Step failed: Parent Action $actionId not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return null;
    }

    // TODO: Add validation for updated actionStep.type and actionStep.parameters

    // Prepare the step for update
    // IMPORTANT: Use the INCOMING actionStep to get the updated fields
    ActionStep stepToUpdate = existingStep.copyWith(
      // Fields being updated from input:
      type: actionStep.type,
      parameters: actionStep.parameters,
      instruction: actionStep.instruction,
      order: actionStep.order,
      // Update timestamp
      updatedAt: DateTime.now().toUtc(),
    );

    ActionStep? updatedStep = await ActionStep.db.updateRow(
      session,
      stepToUpdate,
    );
    session.log(
      'Updated ActionStep id: ${updatedStep.id}',
      level: LogLevel.info,
    );
    return updatedStep;
  }

  /// Deletes an ActionStep by its ID.
  /// Verifies ownership of the parent Action.
  Future<bool> deleteActionStep(Session session, int actionStepId) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find the step to be deleted
    ActionStep? stepToDelete = await ActionStep.db.findById(
      session,
      actionStepId,
    );
    if (stepToDelete == null) {
      session.log(
        'Delete Step failed: Step $actionStepId not found.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Verify ownership of the parent Action
    final actionId = stepToDelete.actionId;
    Action? parentAction = await Action.db.findById(session, actionId);
    if (parentAction == null || parentAction.userInfoId != userId) {
      session.log(
        'Delete Step failed: Parent Action $actionId not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Perform the actual deletion (hard delete)
    // Pass the object itself to deleteRow
    await ActionStep.db.deleteRow(session, stepToDelete);

    // Assume success if no exception was thrown during deleteRow
    // (deleteRow returns void)
    session.log('Deleted ActionStep id: $actionStepId', level: LogLevel.info);
    return true;

    // Previous implementation with row count check (delete returns void now):
    // int? deletedRowCount = await ActionStep.db.deleteRow(
    //   session,
    //   where: (step) => step.id.equals(actionStepId),
    // );
    // bool success = deletedRowCount == 1;
    // session.log(
    //   '${success ? 'Deleted' : 'Failed to delete'} ActionStep id: $actionStepId',
    //   level: success ? LogLevel.info : LogLevel.error,
    // );
    // return success;
  }

  /// Reorders the ActionSteps for a given Action.
  /// Verifies ownership of the Action.
  /// Expects a list of ActionStep IDs in the desired new order.
  Future<bool> reorderActionSteps(
    Session session,
    int actionId,
    List<int> orderedStepIds,
  ) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(session, actionId);
    if (parentAction == null || parentAction.userInfoId != userId) {
      session.log(
        'Reorder Steps failed: Action $actionId not found or user $userId not owner.',
        level: LogLevel.warning,
      );
      return false;
    }

    try {
      // Use a transaction to ensure all updates succeed or fail together
      await session.db.transaction((transaction) async {
        // Fetch all existing steps for this action to verify IDs
        final existingSteps = await ActionStep.db.find(
          session,
          where: (step) => step.actionId.equals(actionId),
          transaction: transaction,
        );
        final existingStepIds = existingSteps.map((s) => s.id).toSet();

        // Validate that all provided IDs belong to this action
        if (orderedStepIds.any((id) => !existingStepIds.contains(id))) {
          throw Exception('Invalid step ID provided in reorder list.');
        }
        // Validate that all existing steps are included in the provided list
        if (existingStepIds.length != orderedStepIds.length) {
          throw Exception(
            'Mismatch between provided step IDs and existing steps.',
          );
        }

        // Update the order for each step based on the new list index
        for (int i = 0; i < orderedStepIds.length; i++) {
          final stepId = orderedStepIds[i];
          final newOrder = i + 1; // Order starts from 1

          // Find the corresponding step object to update
          // This is slightly inefficient but necessary without direct batch update by ID
          final stepToUpdate = existingSteps.firstWhere((s) => s.id == stepId);

          // Only update if the order actually changed
          if (stepToUpdate.order != newOrder) {
            await ActionStep.db.updateRow(
              session,
              stepToUpdate.copyWith(
                order: newOrder,
                updatedAt: DateTime.now().toUtc(),
              ),
              transaction: transaction,
            );
          }
        }

        // Update the parent action's updatedAt timestamp
        await Action.db.updateRow(
          session,
          parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
          transaction: transaction,
        );
      });

      session.log(
        'Reordered steps for Action id: $actionId',
        level: LogLevel.info,
      );
      return true;
    } catch (e) {
      session.log(
        'Reorder Steps failed for Action $actionId: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  // --- Webhook Methods ---

  /// Adds a new Webhook to an existing Action.
  /// Verifies ownership of the parent Action.
  Future<Webhook?> addWebhook(Session session, Webhook webhook) async {
    // Placeholder - move to WebhookEndpoint
    throw UnimplementedError('Webhook operations should be in WebhookEndpoint');
  }

  /// Updates an existing Webhook.
  /// Verifies ownership of the parent Action.
  Future<Webhook?> updateWebhook(Session session, Webhook webhook) async {
    // Placeholder - move to WebhookEndpoint
    throw UnimplementedError('Webhook operations should be in WebhookEndpoint');
  }

  /// Deletes a Webhook by its ID.
  /// Verifies ownership of the parent Action.
  Future<bool> deleteWebhook(Session session, int webhookId) async {
    // Placeholder - move to WebhookEndpoint
    throw UnimplementedError('Webhook operations should be in WebhookEndpoint');
  }
}

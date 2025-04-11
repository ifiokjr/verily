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
    session.log(
      'Updated Action id: ${updatedAction?.id}',
      level: LogLevel.info,
    );
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

  // --- ActionStep Methods ---

  /// Adds a new ActionStep to an existing Action.
  /// Verifies ownership of the parent Action.
  Future<ActionStep?> addActionStep(
    Session session,
    ActionStep actionStep,
  ) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(
      session,
      actionStep.actionId,
    );
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Add Step failed: Parent Action ${actionStep.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return null;
    }

    // TODO: Potentially validate step order uniqueness within the action

    // Prepare the new ActionStep object
    ActionStep stepToAdd = actionStep.copyWith(
      // Ensure parent actionId is set correctly
      actionId: parentAction.id!,
      // Set timestamps
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    ActionStep? createdStep = await ActionStep.db.insertRow(session, stepToAdd);
    if (createdStep != null) {
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Added ActionStep id: ${createdStep.id} to Action id: ${parentAction.id}',
        level: LogLevel.info,
      );
    }
    return createdStep;
  }

  /// Updates an existing ActionStep.
  /// Verifies ownership of the parent Action.
  Future<ActionStep?> updateActionStep(
    Session session,
    ActionStep actionStep,
  ) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find the existing step to get parent action ID and verify existence
    ActionStep? existingStep = await ActionStep.db.findById(
      session,
      actionStep.id!,
    );
    if (existingStep == null) {
      session.log(
        'Update Step failed: ActionStep ${actionStep.id} not found.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(
      session,
      existingStep.actionId,
    );
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Update Step failed: Parent Action ${existingStep.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return null;
    }

    // TODO: Potentially validate step order uniqueness within the action if order changed

    // Prepare updated step, preserving original createdAt and actionId
    ActionStep stepToUpdate = actionStep.copyWith(
      actionId: existingStep.actionId, // Preserve parent action
      createdAt: existingStep.createdAt, // Preserve original creation time
      updatedAt: DateTime.now().toUtc(),
    );

    ActionStep? updatedStep = await ActionStep.db.updateRow(
      session,
      stepToUpdate,
    );
    if (updatedStep != null) {
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Updated ActionStep id: ${updatedStep.id}',
        level: LogLevel.info,
      );
    }
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

    // Find the existing step to get parent action ID
    ActionStep? stepToDelete = await ActionStep.db.findById(
      session,
      actionStepId,
    );
    if (stepToDelete == null) {
      session.log(
        'Delete Step failed: ActionStep $actionStepId not found.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(
      session,
      stepToDelete.actionId,
    );
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Delete Step failed: Parent Action ${stepToDelete.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Perform the delete
    try {
      await ActionStep.db.deleteRow(session, stepToDelete);
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Deleted ActionStep id: $actionStepId from Action id: ${parentAction.id}',
        level: LogLevel.info,
      );
      return true;
    } catch (e) {
      session.log(
        'Delete Step failed for ActionStep id: $actionStepId',
        level: LogLevel.error,
      );

      return false;
    }
  }

  // --- Webhook Methods ---

  /// Adds a new Webhook to an existing Action.
  /// Verifies ownership of the parent Action.
  Future<Webhook?> addWebhook(Session session, Webhook webhook) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(session, webhook.actionId);
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Add Webhook failed: Parent Action ${webhook.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Prepare the new Webhook object
    Webhook hookToAdd = webhook.copyWith(
      actionId: parentAction.id!,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      // Ensure isActive defaults if not provided, or use provided value
      isActive: webhook.isActive ?? true,
    );

    Webhook? createdHook = await Webhook.db.insertRow(session, hookToAdd);
    if (createdHook != null) {
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Added Webhook id: ${createdHook.id} to Action id: ${parentAction.id}',
        level: LogLevel.info,
      );
    }
    return createdHook;
  }

  /// Updates an existing Webhook.
  /// Verifies ownership of the parent Action.
  Future<Webhook?> updateWebhook(Session session, Webhook webhook) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find existing webhook to get parent action ID
    Webhook? existingHook = await Webhook.db.findById(session, webhook.id!);
    if (existingHook == null) {
      session.log(
        'Update Webhook failed: Webhook ${webhook.id} not found.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(
      session,
      existingHook.actionId,
    );
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Update Webhook failed: Parent Action ${existingHook.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return null;
    }

    // Prepare updated webhook
    Webhook hookToUpdate = webhook.copyWith(
      actionId: existingHook.actionId, // Preserve parent action
      createdAt: existingHook.createdAt, // Preserve original creation time
      updatedAt: DateTime.now().toUtc(),
    );

    Webhook? updatedHook = await Webhook.db.updateRow(session, hookToUpdate);
    if (updatedHook != null) {
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Updated Webhook id: ${updatedHook.id}',
        level: LogLevel.info,
      );
    }
    return updatedHook;
  }

  /// Deletes a Webhook by its ID.
  /// Verifies ownership of the parent Action.
  Future<bool> deleteWebhook(Session session, int webhookId) async {
    final authenticationInfo = await session.authenticated;
    final userId = authenticationInfo?.userId;
    if (userId == null) {
      throw Exception('User authentication failed unexpectedly.');
    }

    // Find existing webhook to get parent action ID
    Webhook? hookToDelete = await Webhook.db.findById(session, webhookId);
    if (hookToDelete == null) {
      session.log(
        'Delete Webhook failed: Webhook $webhookId not found.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Verify ownership of the parent Action
    Action? parentAction = await Action.db.findById(
      session,
      hookToDelete.actionId,
    );
    if (parentAction == null ||
        parentAction.userInfoId != userId ||
        parentAction.isDeleted) {
      session.log(
        'Delete Webhook failed: Parent Action ${hookToDelete.actionId} not found, user $userId not owner, or action deleted.',
        level: LogLevel.warning,
      );
      return false;
    }

    // Perform delete
    try {
      await Webhook.db.deleteRow(session, hookToDelete);
      // Update parent action's updatedAt timestamp
      await Action.db.updateRow(
        session,
        parentAction.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      session.log(
        'Deleted Webhook id: $webhookId from Action id: ${parentAction.id}',
        level: LogLevel.info,
      );
      return true;
    } catch (e) {
      session.log(
        'Delete Webhook failed for Webhook id: $webhookId',
        level: LogLevel.error,
      );
      return false;
    }
  }
}

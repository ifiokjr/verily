import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
// Import the generated protocol (contains Action, etc.)
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
  }) async {
    // Get the authenticated user's ID. `requireLogin` ensures this won't be null.
    int userId = (await session.auth.authenticatedUserId)!;

    // Prepare the new Action object.
    Action newAction = Action(
      creatorId: userId,
      name: name,
      description: description,
      createdAt: DateTime.now().toUtc(), // Store in UTC
    );

    // Insert into the database.
    Action createdAction = await Action.db.insertRow(session, newAction);
    session.log('Created Action id: ${createdAction.id}', level: LogLevel.info);
    return createdAction;
  }

  /// Retrieves a list of Actions created by the authenticated user.
  Future<List<Action>> getMyActions(Session session) async {
    // Get the authenticated user's ID.
    int userId = (await session.auth.authenticatedUserId)!;

    // Find actions belonging to this user.
    List<Action> actions = await Action.db.find(
      session,
      where: (action) => action.creatorId.equals(userId),
      orderBy: (action) => action.createdAt,
      orderDescending: true,
    );

    session.log(
      'Fetched ${actions.length} actions for user $userId',
      level: LogLevel.debug,
    );
    return actions;
  }

  // Note: Add other methods like update, delete, addStep as needed.
}

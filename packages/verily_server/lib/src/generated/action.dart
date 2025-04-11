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
import 'action_step.dart' as _i2;
import 'webhook.dart' as _i3;

abstract class Action implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  Action._({
    this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    bool? isDeleted,
    this.steps,
    this.webhooks,
  }) : isDeleted = isDeleted ?? false;

  factory Action({
    int? id,
    required String name,
    String? description,
    required int creatorId,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  }) = _ActionImpl;

  factory Action.fromJson(Map<String, dynamic> jsonSerialization) {
    return Action(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      creatorId: jsonSerialization['creatorId'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      isDeleted: jsonSerialization['isDeleted'] as bool,
      steps: (jsonSerialization['steps'] as List?)
          ?.map((e) => _i2.ActionStep.fromJson((e as Map<String, dynamic>)))
          .toList(),
      webhooks: (jsonSerialization['webhooks'] as List?)
          ?.map((e) => _i3.Webhook.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = ActionTable();

  static const db = ActionRepository._();

  @override
  int? id;

  String name;

  String? description;

  int creatorId;

  DateTime createdAt;

  DateTime updatedAt;

  bool isDeleted;

  List<_i2.ActionStep>? steps;

  List<_i3.Webhook>? webhooks;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Action copyWith({
    int? id,
    String? name,
    String? description,
    int? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'creatorId': creatorId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isDeleted': isDeleted,
      if (steps != null) 'steps': steps?.toJson(valueToJson: (v) => v.toJson()),
      if (webhooks != null)
        'webhooks': webhooks?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'creatorId': creatorId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isDeleted': isDeleted,
      if (steps != null)
        'steps': steps?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (webhooks != null)
        'webhooks': webhooks?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ActionInclude include({
    _i2.ActionStepIncludeList? steps,
    _i3.WebhookIncludeList? webhooks,
  }) {
    return ActionInclude._(
      steps: steps,
      webhooks: webhooks,
    );
  }

  static ActionIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    ActionInclude? include,
  }) {
    return ActionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Action.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Action.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionImpl extends Action {
  _ActionImpl({
    int? id,
    required String name,
    String? description,
    required int creatorId,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool? isDeleted,
    List<_i2.ActionStep>? steps,
    List<_i3.Webhook>? webhooks,
  }) : super._(
          id: id,
          name: name,
          description: description,
          creatorId: creatorId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isDeleted: isDeleted,
          steps: steps,
          webhooks: webhooks,
        );

  /// Returns a shallow copy of this [Action]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Action copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    int? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Object? steps = _Undefined,
    Object? webhooks = _Undefined,
  }) {
    return Action(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      steps: steps is List<_i2.ActionStep>?
          ? steps
          : this.steps?.map((e0) => e0.copyWith()).toList(),
      webhooks: webhooks is List<_i3.Webhook>?
          ? webhooks
          : this.webhooks?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ActionTable extends _i1.Table<int> {
  ActionTable({super.tableRelation}) : super(tableName: 'action') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    creatorId = _i1.ColumnInt(
      'creatorId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt creatorId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnBool isDeleted;

  _i2.ActionStepTable? ___steps;

  _i1.ManyRelation<_i2.ActionStepTable>? _steps;

  _i3.WebhookTable? ___webhooks;

  _i1.ManyRelation<_i3.WebhookTable>? _webhooks;

  _i2.ActionStepTable get __steps {
    if (___steps != null) return ___steps!;
    ___steps = _i1.createRelationTable(
      relationFieldName: '__steps',
      field: Action.t.id,
      foreignField: _i2.ActionStep.t.$_actionStepsActionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ActionStepTable(tableRelation: foreignTableRelation),
    );
    return ___steps!;
  }

  _i3.WebhookTable get __webhooks {
    if (___webhooks != null) return ___webhooks!;
    ___webhooks = _i1.createRelationTable(
      relationFieldName: '__webhooks',
      field: Action.t.id,
      foreignField: _i3.Webhook.t.$_actionWebhooksActionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.WebhookTable(tableRelation: foreignTableRelation),
    );
    return ___webhooks!;
  }

  _i1.ManyRelation<_i2.ActionStepTable> get steps {
    if (_steps != null) return _steps!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'steps',
      field: Action.t.id,
      foreignField: _i2.ActionStep.t.$_actionStepsActionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ActionStepTable(tableRelation: foreignTableRelation),
    );
    _steps = _i1.ManyRelation<_i2.ActionStepTable>(
      tableWithRelations: relationTable,
      table: _i2.ActionStepTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _steps!;
  }

  _i1.ManyRelation<_i3.WebhookTable> get webhooks {
    if (_webhooks != null) return _webhooks!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'webhooks',
      field: Action.t.id,
      foreignField: _i3.Webhook.t.$_actionWebhooksActionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.WebhookTable(tableRelation: foreignTableRelation),
    );
    _webhooks = _i1.ManyRelation<_i3.WebhookTable>(
      tableWithRelations: relationTable,
      table: _i3.WebhookTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _webhooks!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        creatorId,
        createdAt,
        updatedAt,
        isDeleted,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'steps') {
      return __steps;
    }
    if (relationField == 'webhooks') {
      return __webhooks;
    }
    return null;
  }
}

class ActionInclude extends _i1.IncludeObject {
  ActionInclude._({
    _i2.ActionStepIncludeList? steps,
    _i3.WebhookIncludeList? webhooks,
  }) {
    _steps = steps;
    _webhooks = webhooks;
  }

  _i2.ActionStepIncludeList? _steps;

  _i3.WebhookIncludeList? _webhooks;

  @override
  Map<String, _i1.Include?> get includes => {
        'steps': _steps,
        'webhooks': _webhooks,
      };

  @override
  _i1.Table<int> get table => Action.t;
}

class ActionIncludeList extends _i1.IncludeList {
  ActionIncludeList._({
    _i1.WhereExpressionBuilder<ActionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Action.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => Action.t;
}

class ActionRepository {
  const ActionRepository._();

  final attach = const ActionAttachRepository._();

  final attachRow = const ActionAttachRowRepository._();

  final detach = const ActionDetachRepository._();

  final detachRow = const ActionDetachRowRepository._();

  /// Returns a list of [Action]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Action>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
    ActionInclude? include,
  }) async {
    return session.db.find<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Action] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Action?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionTable>? orderByList,
    _i1.Transaction? transaction,
    ActionInclude? include,
  }) async {
    return session.db.findFirstRow<Action>(
      where: where?.call(Action.t),
      orderBy: orderBy?.call(Action.t),
      orderByList: orderByList?.call(Action.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Action] by its [id] or null if no such row exists.
  Future<Action?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ActionInclude? include,
  }) async {
    return session.db.findById<Action>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Action]s in the list and returns the inserted rows.
  ///
  /// The returned [Action]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Action>> insert(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Action] and returns the inserted row.
  ///
  /// The returned [Action] will have its `id` field set.
  Future<Action> insertRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Action]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Action>> update(
    _i1.Session session,
    List<Action> rows, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Action>(
      rows,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Action]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Action> updateRow(
    _i1.Session session,
    Action row, {
    _i1.ColumnSelections<ActionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Action>(
      row,
      columns: columns?.call(Action.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Action]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Action>> delete(
    _i1.Session session,
    List<Action> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Action>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Action].
  Future<Action> deleteRow(
    _i1.Session session,
    Action row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Action>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Action>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Action>(
      where: where(Action.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Action>(
      where: where?.call(Action.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ActionAttachRepository {
  const ActionAttachRepository._();

  /// Creates a relation between this [Action] and the given [ActionStep]s
  /// by setting each [ActionStep]'s foreign key `_actionStepsActionId` to refer to this [Action].
  Future<void> steps(
    _i1.Session session,
    Action action,
    List<_i2.ActionStep> actionStep, {
    _i1.Transaction? transaction,
  }) async {
    if (actionStep.any((e) => e.id == null)) {
      throw ArgumentError.notNull('actionStep.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $actionStep = actionStep
        .map((e) => _i2.ActionStepImplicit(
              e,
              $_actionStepsActionId: action.id,
            ))
        .toList();
    await session.db.update<_i2.ActionStep>(
      $actionStep,
      columns: [_i2.ActionStep.t.$_actionStepsActionId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Action] and the given [Webhook]s
  /// by setting each [Webhook]'s foreign key `_actionWebhooksActionId` to refer to this [Action].
  Future<void> webhooks(
    _i1.Session session,
    Action action,
    List<_i3.Webhook> webhook, {
    _i1.Transaction? transaction,
  }) async {
    if (webhook.any((e) => e.id == null)) {
      throw ArgumentError.notNull('webhook.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $webhook = webhook
        .map((e) => _i3.WebhookImplicit(
              e,
              $_actionWebhooksActionId: action.id,
            ))
        .toList();
    await session.db.update<_i3.Webhook>(
      $webhook,
      columns: [_i3.Webhook.t.$_actionWebhooksActionId],
      transaction: transaction,
    );
  }
}

class ActionAttachRowRepository {
  const ActionAttachRowRepository._();

  /// Creates a relation between this [Action] and the given [ActionStep]
  /// by setting the [ActionStep]'s foreign key `_actionStepsActionId` to refer to this [Action].
  Future<void> steps(
    _i1.Session session,
    Action action,
    _i2.ActionStep actionStep, {
    _i1.Transaction? transaction,
  }) async {
    if (actionStep.id == null) {
      throw ArgumentError.notNull('actionStep.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $actionStep = _i2.ActionStepImplicit(
      actionStep,
      $_actionStepsActionId: action.id,
    );
    await session.db.updateRow<_i2.ActionStep>(
      $actionStep,
      columns: [_i2.ActionStep.t.$_actionStepsActionId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Action] and the given [Webhook]
  /// by setting the [Webhook]'s foreign key `_actionWebhooksActionId` to refer to this [Action].
  Future<void> webhooks(
    _i1.Session session,
    Action action,
    _i3.Webhook webhook, {
    _i1.Transaction? transaction,
  }) async {
    if (webhook.id == null) {
      throw ArgumentError.notNull('webhook.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $webhook = _i3.WebhookImplicit(
      webhook,
      $_actionWebhooksActionId: action.id,
    );
    await session.db.updateRow<_i3.Webhook>(
      $webhook,
      columns: [_i3.Webhook.t.$_actionWebhooksActionId],
      transaction: transaction,
    );
  }
}

class ActionDetachRepository {
  const ActionDetachRepository._();

  /// Detaches the relation between this [Action] and the given [ActionStep]
  /// by setting the [ActionStep]'s foreign key `_actionStepsActionId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> steps(
    _i1.Session session,
    List<_i2.ActionStep> actionStep, {
    _i1.Transaction? transaction,
  }) async {
    if (actionStep.any((e) => e.id == null)) {
      throw ArgumentError.notNull('actionStep.id');
    }

    var $actionStep = actionStep
        .map((e) => _i2.ActionStepImplicit(
              e,
              $_actionStepsActionId: null,
            ))
        .toList();
    await session.db.update<_i2.ActionStep>(
      $actionStep,
      columns: [_i2.ActionStep.t.$_actionStepsActionId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Action] and the given [Webhook]
  /// by setting the [Webhook]'s foreign key `_actionWebhooksActionId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> webhooks(
    _i1.Session session,
    List<_i3.Webhook> webhook, {
    _i1.Transaction? transaction,
  }) async {
    if (webhook.any((e) => e.id == null)) {
      throw ArgumentError.notNull('webhook.id');
    }

    var $webhook = webhook
        .map((e) => _i3.WebhookImplicit(
              e,
              $_actionWebhooksActionId: null,
            ))
        .toList();
    await session.db.update<_i3.Webhook>(
      $webhook,
      columns: [_i3.Webhook.t.$_actionWebhooksActionId],
      transaction: transaction,
    );
  }
}

class ActionDetachRowRepository {
  const ActionDetachRowRepository._();

  /// Detaches the relation between this [Action] and the given [ActionStep]
  /// by setting the [ActionStep]'s foreign key `_actionStepsActionId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> steps(
    _i1.Session session,
    _i2.ActionStep actionStep, {
    _i1.Transaction? transaction,
  }) async {
    if (actionStep.id == null) {
      throw ArgumentError.notNull('actionStep.id');
    }

    var $actionStep = _i2.ActionStepImplicit(
      actionStep,
      $_actionStepsActionId: null,
    );
    await session.db.updateRow<_i2.ActionStep>(
      $actionStep,
      columns: [_i2.ActionStep.t.$_actionStepsActionId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Action] and the given [Webhook]
  /// by setting the [Webhook]'s foreign key `_actionWebhooksActionId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> webhooks(
    _i1.Session session,
    _i3.Webhook webhook, {
    _i1.Transaction? transaction,
  }) async {
    if (webhook.id == null) {
      throw ArgumentError.notNull('webhook.id');
    }

    var $webhook = _i3.WebhookImplicit(
      webhook,
      $_actionWebhooksActionId: null,
    );
    await session.db.updateRow<_i3.Webhook>(
      $webhook,
      columns: [_i3.Webhook.t.$_actionWebhooksActionId],
      transaction: transaction,
    );
  }
}

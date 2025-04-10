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
import 'action.dart' as _i2;

abstract class ActionStep
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  ActionStep._({
    this.id,
    required this.actionId,
    this.action,
    required this.stepType,
    required this.parameters,
    required this.order,
    required this.createdAt,
  }) : _actionStepsActionId = null;

  factory ActionStep({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String stepType,
    required String parameters,
    required int order,
    required DateTime createdAt,
  }) = _ActionStepImpl;

  factory ActionStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionStepImplicit._(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      action:
          jsonSerialization['action'] == null
              ? null
              : _i2.Action.fromJson(
                (jsonSerialization['action'] as Map<String, dynamic>),
              ),
      stepType: jsonSerialization['stepType'] as String,
      parameters: jsonSerialization['parameters'] as String,
      order: jsonSerialization['order'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      $_actionStepsActionId: jsonSerialization['_actionStepsActionId'] as int?,
    );
  }

  static final t = ActionStepTable();

  static const db = ActionStepRepository._();

  @override
  int? id;

  int actionId;

  _i2.Action? action;

  String stepType;

  String parameters;

  int order;

  DateTime createdAt;

  final int? _actionStepsActionId;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActionStep copyWith({
    int? id,
    int? actionId,
    _i2.Action? action,
    String? stepType,
    String? parameters,
    int? order,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJson(),
      'stepType': stepType,
      'parameters': parameters,
      'order': order,
      'createdAt': createdAt.toJson(),
      if (_actionStepsActionId != null)
        '_actionStepsActionId': _actionStepsActionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJsonForProtocol(),
      'stepType': stepType,
      'parameters': parameters,
      'order': order,
      'createdAt': createdAt.toJson(),
    };
  }

  static ActionStepInclude include({_i2.ActionInclude? action}) {
    return ActionStepInclude._(action: action);
  }

  static ActionStepIncludeList includeList({
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    ActionStepInclude? include,
  }) {
    return ActionStepIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionStep.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ActionStep.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionStepImpl extends ActionStep {
  _ActionStepImpl({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String stepType,
    required String parameters,
    required int order,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actionId: actionId,
         action: action,
         stepType: stepType,
         parameters: parameters,
         order: order,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ActionStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActionStep copyWith({
    Object? id = _Undefined,
    int? actionId,
    Object? action = _Undefined,
    String? stepType,
    String? parameters,
    int? order,
    DateTime? createdAt,
  }) {
    return ActionStepImplicit._(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      action: action is _i2.Action? ? action : this.action?.copyWith(),
      stepType: stepType ?? this.stepType,
      parameters: parameters ?? this.parameters,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      $_actionStepsActionId: _actionStepsActionId,
    );
  }
}

class ActionStepImplicit extends _ActionStepImpl {
  ActionStepImplicit._({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String stepType,
    required String parameters,
    required int order,
    required DateTime createdAt,
    int? $_actionStepsActionId,
  }) : _actionStepsActionId = $_actionStepsActionId,
       super(
         id: id,
         actionId: actionId,
         action: action,
         stepType: stepType,
         parameters: parameters,
         order: order,
         createdAt: createdAt,
       );

  factory ActionStepImplicit(
    ActionStep actionStep, {
    int? $_actionStepsActionId,
  }) {
    return ActionStepImplicit._(
      id: actionStep.id,
      actionId: actionStep.actionId,
      action: actionStep.action,
      stepType: actionStep.stepType,
      parameters: actionStep.parameters,
      order: actionStep.order,
      createdAt: actionStep.createdAt,
      $_actionStepsActionId: $_actionStepsActionId,
    );
  }

  @override
  final int? _actionStepsActionId;
}

class ActionStepTable extends _i1.Table<int> {
  ActionStepTable({super.tableRelation}) : super(tableName: 'action_step') {
    actionId = _i1.ColumnInt('actionId', this);
    stepType = _i1.ColumnString('stepType', this);
    parameters = _i1.ColumnString('parameters', this);
    order = _i1.ColumnInt('order', this);
    createdAt = _i1.ColumnDateTime('createdAt', this);
    $_actionStepsActionId = _i1.ColumnInt('_actionStepsActionId', this);
  }

  late final _i1.ColumnInt actionId;

  _i2.ActionTable? _action;

  late final _i1.ColumnString stepType;

  late final _i1.ColumnString parameters;

  late final _i1.ColumnInt order;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt $_actionStepsActionId;

  _i2.ActionTable get action {
    if (_action != null) return _action!;
    _action = _i1.createRelationTable(
      relationFieldName: 'action',
      field: ActionStep.t.actionId,
      foreignField: _i2.Action.t.id,
      tableRelation: tableRelation,
      createTable:
          (foreignTableRelation) =>
              _i2.ActionTable(tableRelation: foreignTableRelation),
    );
    return _action!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    actionId,
    stepType,
    parameters,
    order,
    createdAt,
    $_actionStepsActionId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    actionId,
    stepType,
    parameters,
    order,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'action') {
      return action;
    }
    return null;
  }
}

class ActionStepInclude extends _i1.IncludeObject {
  ActionStepInclude._({_i2.ActionInclude? action}) {
    _action = action;
  }

  _i2.ActionInclude? _action;

  @override
  Map<String, _i1.Include?> get includes => {'action': _action};

  @override
  _i1.Table<int> get table => ActionStep.t;
}

class ActionStepIncludeList extends _i1.IncludeList {
  ActionStepIncludeList._({
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActionStep.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => ActionStep.t;
}

class ActionStepRepository {
  const ActionStepRepository._();

  final attachRow = const ActionStepAttachRowRepository._();

  /// Returns a list of [ActionStep]s matching the given query parameters.
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
  Future<List<ActionStep>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    _i1.Transaction? transaction,
    ActionStepInclude? include,
  }) async {
    return session.db.find<ActionStep>(
      where: where?.call(ActionStep.t),
      orderBy: orderBy?.call(ActionStep.t),
      orderByList: orderByList?.call(ActionStep.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ActionStep] matching the given query parameters.
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
  Future<ActionStep?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActionStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActionStepTable>? orderByList,
    _i1.Transaction? transaction,
    ActionStepInclude? include,
  }) async {
    return session.db.findFirstRow<ActionStep>(
      where: where?.call(ActionStep.t),
      orderBy: orderBy?.call(ActionStep.t),
      orderByList: orderByList?.call(ActionStep.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ActionStep] by its [id] or null if no such row exists.
  Future<ActionStep?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ActionStepInclude? include,
  }) async {
    return session.db.findById<ActionStep>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ActionStep]s in the list and returns the inserted rows.
  ///
  /// The returned [ActionStep]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ActionStep>> insert(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ActionStep>(rows, transaction: transaction);
  }

  /// Inserts a single [ActionStep] and returns the inserted row.
  ///
  /// The returned [ActionStep] will have its `id` field set.
  Future<ActionStep> insertRow(
    _i1.Session session,
    ActionStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActionStep>(row, transaction: transaction);
  }

  /// Updates all [ActionStep]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ActionStep>> update(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.ColumnSelections<ActionStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ActionStep>(
      rows,
      columns: columns?.call(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionStep]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActionStep> updateRow(
    _i1.Session session,
    ActionStep row, {
    _i1.ColumnSelections<ActionStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActionStep>(
      row,
      columns: columns?.call(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ActionStep]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ActionStep>> delete(
    _i1.Session session,
    List<ActionStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ActionStep>(rows, transaction: transaction);
  }

  /// Deletes a single [ActionStep].
  Future<ActionStep> deleteRow(
    _i1.Session session,
    ActionStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActionStep>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ActionStep>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActionStepTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ActionStep>(
      where: where(ActionStep.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActionStepTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ActionStep>(
      where: where?.call(ActionStep.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ActionStepAttachRowRepository {
  const ActionStepAttachRowRepository._();

  /// Creates a relation between the given [ActionStep] and [Action]
  /// by setting the [ActionStep]'s foreign key `actionId` to refer to the [Action].
  Future<void> action(
    _i1.Session session,
    ActionStep actionStep,
    _i2.Action action, {
    _i1.Transaction? transaction,
  }) async {
    if (actionStep.id == null) {
      throw ArgumentError.notNull('actionStep.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $actionStep = actionStep.copyWith(actionId: action.id);
    await session.db.updateRow<ActionStep>(
      $actionStep,
      columns: [ActionStep.t.actionId],
      transaction: transaction,
    );
  }
}

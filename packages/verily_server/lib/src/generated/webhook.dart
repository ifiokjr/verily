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

abstract class Webhook implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  Webhook._({
    this.id,
    required this.actionId,
    this.action,
    required this.url,
    required this.secret,
    required this.triggerEvents,
    required this.createdAt,
  }) : _actionWebhooksActionId = null;

  factory Webhook({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String url,
    required String secret,
    required String triggerEvents,
    required DateTime createdAt,
  }) = _WebhookImpl;

  factory Webhook.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookImplicit._(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      action: jsonSerialization['action'] == null
          ? null
          : _i2.Action.fromJson(
              (jsonSerialization['action'] as Map<String, dynamic>)),
      url: jsonSerialization['url'] as String,
      secret: jsonSerialization['secret'] as String,
      triggerEvents: jsonSerialization['triggerEvents'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      $_actionWebhooksActionId:
          jsonSerialization['_actionWebhooksActionId'] as int?,
    );
  }

  static final t = WebhookTable();

  static const db = WebhookRepository._();

  @override
  int? id;

  int actionId;

  _i2.Action? action;

  String url;

  String secret;

  String triggerEvents;

  DateTime createdAt;

  final int? _actionWebhooksActionId;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Webhook copyWith({
    int? id,
    int? actionId,
    _i2.Action? action,
    String? url,
    String? secret,
    String? triggerEvents,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJson(),
      'url': url,
      'secret': secret,
      'triggerEvents': triggerEvents,
      'createdAt': createdAt.toJson(),
      if (_actionWebhooksActionId != null)
        '_actionWebhooksActionId': _actionWebhooksActionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      if (action != null) 'action': action?.toJsonForProtocol(),
      'url': url,
      'secret': secret,
      'triggerEvents': triggerEvents,
      'createdAt': createdAt.toJson(),
    };
  }

  static WebhookInclude include({_i2.ActionInclude? action}) {
    return WebhookInclude._(action: action);
  }

  static WebhookIncludeList includeList({
    _i1.WhereExpressionBuilder<WebhookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WebhookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookTable>? orderByList,
    WebhookInclude? include,
  }) {
    return WebhookIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Webhook.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Webhook.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookImpl extends Webhook {
  _WebhookImpl({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String url,
    required String secret,
    required String triggerEvents,
    required DateTime createdAt,
  }) : super._(
          id: id,
          actionId: actionId,
          action: action,
          url: url,
          secret: secret,
          triggerEvents: triggerEvents,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Webhook copyWith({
    Object? id = _Undefined,
    int? actionId,
    Object? action = _Undefined,
    String? url,
    String? secret,
    String? triggerEvents,
    DateTime? createdAt,
  }) {
    return WebhookImplicit._(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      action: action is _i2.Action? ? action : this.action?.copyWith(),
      url: url ?? this.url,
      secret: secret ?? this.secret,
      triggerEvents: triggerEvents ?? this.triggerEvents,
      createdAt: createdAt ?? this.createdAt,
      $_actionWebhooksActionId: this._actionWebhooksActionId,
    );
  }
}

class WebhookImplicit extends _WebhookImpl {
  WebhookImplicit._({
    int? id,
    required int actionId,
    _i2.Action? action,
    required String url,
    required String secret,
    required String triggerEvents,
    required DateTime createdAt,
    int? $_actionWebhooksActionId,
  })  : _actionWebhooksActionId = $_actionWebhooksActionId,
        super(
          id: id,
          actionId: actionId,
          action: action,
          url: url,
          secret: secret,
          triggerEvents: triggerEvents,
          createdAt: createdAt,
        );

  factory WebhookImplicit(
    Webhook webhook, {
    int? $_actionWebhooksActionId,
  }) {
    return WebhookImplicit._(
      id: webhook.id,
      actionId: webhook.actionId,
      action: webhook.action,
      url: webhook.url,
      secret: webhook.secret,
      triggerEvents: webhook.triggerEvents,
      createdAt: webhook.createdAt,
      $_actionWebhooksActionId: $_actionWebhooksActionId,
    );
  }

  @override
  final int? _actionWebhooksActionId;
}

class WebhookTable extends _i1.Table<int> {
  WebhookTable({super.tableRelation}) : super(tableName: 'webhook') {
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
    secret = _i1.ColumnString(
      'secret',
      this,
    );
    triggerEvents = _i1.ColumnString(
      'triggerEvents',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    $_actionWebhooksActionId = _i1.ColumnInt(
      '_actionWebhooksActionId',
      this,
    );
  }

  late final _i1.ColumnInt actionId;

  _i2.ActionTable? _action;

  late final _i1.ColumnString url;

  late final _i1.ColumnString secret;

  late final _i1.ColumnString triggerEvents;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt $_actionWebhooksActionId;

  _i2.ActionTable get action {
    if (_action != null) return _action!;
    _action = _i1.createRelationTable(
      relationFieldName: 'action',
      field: Webhook.t.actionId,
      foreignField: _i2.Action.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ActionTable(tableRelation: foreignTableRelation),
    );
    return _action!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        actionId,
        url,
        secret,
        triggerEvents,
        createdAt,
        $_actionWebhooksActionId,
      ];

  @override
  List<_i1.Column> get managedColumns => [
        id,
        actionId,
        url,
        secret,
        triggerEvents,
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

class WebhookInclude extends _i1.IncludeObject {
  WebhookInclude._({_i2.ActionInclude? action}) {
    _action = action;
  }

  _i2.ActionInclude? _action;

  @override
  Map<String, _i1.Include?> get includes => {'action': _action};

  @override
  _i1.Table<int> get table => Webhook.t;
}

class WebhookIncludeList extends _i1.IncludeList {
  WebhookIncludeList._({
    _i1.WhereExpressionBuilder<WebhookTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Webhook.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => Webhook.t;
}

class WebhookRepository {
  const WebhookRepository._();

  final attachRow = const WebhookAttachRowRepository._();

  /// Returns a list of [Webhook]s matching the given query parameters.
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
  Future<List<Webhook>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WebhookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookTable>? orderByList,
    _i1.Transaction? transaction,
    WebhookInclude? include,
  }) async {
    return session.db.find<Webhook>(
      where: where?.call(Webhook.t),
      orderBy: orderBy?.call(Webhook.t),
      orderByList: orderByList?.call(Webhook.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Webhook] matching the given query parameters.
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
  Future<Webhook?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookTable>? where,
    int? offset,
    _i1.OrderByBuilder<WebhookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WebhookTable>? orderByList,
    _i1.Transaction? transaction,
    WebhookInclude? include,
  }) async {
    return session.db.findFirstRow<Webhook>(
      where: where?.call(Webhook.t),
      orderBy: orderBy?.call(Webhook.t),
      orderByList: orderByList?.call(Webhook.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Webhook] by its [id] or null if no such row exists.
  Future<Webhook?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    WebhookInclude? include,
  }) async {
    return session.db.findById<Webhook>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Webhook]s in the list and returns the inserted rows.
  ///
  /// The returned [Webhook]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Webhook>> insert(
    _i1.Session session,
    List<Webhook> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Webhook>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Webhook] and returns the inserted row.
  ///
  /// The returned [Webhook] will have its `id` field set.
  Future<Webhook> insertRow(
    _i1.Session session,
    Webhook row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Webhook>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Webhook]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Webhook>> update(
    _i1.Session session,
    List<Webhook> rows, {
    _i1.ColumnSelections<WebhookTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Webhook>(
      rows,
      columns: columns?.call(Webhook.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Webhook]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Webhook> updateRow(
    _i1.Session session,
    Webhook row, {
    _i1.ColumnSelections<WebhookTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Webhook>(
      row,
      columns: columns?.call(Webhook.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Webhook]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Webhook>> delete(
    _i1.Session session,
    List<Webhook> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Webhook>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Webhook].
  Future<Webhook> deleteRow(
    _i1.Session session,
    Webhook row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Webhook>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Webhook>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WebhookTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Webhook>(
      where: where(Webhook.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WebhookTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Webhook>(
      where: where?.call(Webhook.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class WebhookAttachRowRepository {
  const WebhookAttachRowRepository._();

  /// Creates a relation between the given [Webhook] and [Action]
  /// by setting the [Webhook]'s foreign key `actionId` to refer to the [Action].
  Future<void> action(
    _i1.Session session,
    Webhook webhook,
    _i2.Action action, {
    _i1.Transaction? transaction,
  }) async {
    if (webhook.id == null) {
      throw ArgumentError.notNull('webhook.id');
    }
    if (action.id == null) {
      throw ArgumentError.notNull('action.id');
    }

    var $webhook = webhook.copyWith(actionId: action.id);
    await session.db.updateRow<Webhook>(
      $webhook,
      columns: [Webhook.t.actionId],
      transaction: transaction,
    );
  }
}

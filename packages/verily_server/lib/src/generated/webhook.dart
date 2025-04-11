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

abstract class Webhook implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  Webhook._({
    this.id,
    required this.actionId,
    required this.url,
    this.secret,
    required this.subscribedEvents,
    bool? isActive,
    required this.createdAt,
    required this.updatedAt,
  })  : isActive = isActive ?? true,
        _actionWebhooksActionId = null;

  factory Webhook({
    int? id,
    required int actionId,
    required String url,
    String? secret,
    required String subscribedEvents,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WebhookImpl;

  factory Webhook.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookImplicit._(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      url: jsonSerialization['url'] as String,
      secret: jsonSerialization['secret'] as String?,
      subscribedEvents: jsonSerialization['subscribedEvents'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      $_actionWebhooksActionId:
          jsonSerialization['_actionWebhooksActionId'] as int?,
    );
  }

  static final t = WebhookTable();

  static const db = WebhookRepository._();

  @override
  int? id;

  int actionId;

  String url;

  String? secret;

  String subscribedEvents;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  final int? _actionWebhooksActionId;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Webhook copyWith({
    int? id,
    int? actionId,
    String? url,
    String? secret,
    String? subscribedEvents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'url': url,
      if (secret != null) 'secret': secret,
      'subscribedEvents': subscribedEvents,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (_actionWebhooksActionId != null)
        '_actionWebhooksActionId': _actionWebhooksActionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'url': url,
      if (secret != null) 'secret': secret,
      'subscribedEvents': subscribedEvents,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WebhookInclude include() {
    return WebhookInclude._();
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
    required String url,
    String? secret,
    required String subscribedEvents,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          actionId: actionId,
          url: url,
          secret: secret,
          subscribedEvents: subscribedEvents,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [Webhook]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Webhook copyWith({
    Object? id = _Undefined,
    int? actionId,
    String? url,
    Object? secret = _Undefined,
    String? subscribedEvents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WebhookImplicit._(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      url: url ?? this.url,
      secret: secret is String? ? secret : this.secret,
      subscribedEvents: subscribedEvents ?? this.subscribedEvents,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      $_actionWebhooksActionId: this._actionWebhooksActionId,
    );
  }
}

class WebhookImplicit extends _WebhookImpl {
  WebhookImplicit._({
    int? id,
    required int actionId,
    required String url,
    String? secret,
    required String subscribedEvents,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? $_actionWebhooksActionId,
  })  : _actionWebhooksActionId = $_actionWebhooksActionId,
        super(
          id: id,
          actionId: actionId,
          url: url,
          secret: secret,
          subscribedEvents: subscribedEvents,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory WebhookImplicit(
    Webhook webhook, {
    int? $_actionWebhooksActionId,
  }) {
    return WebhookImplicit._(
      id: webhook.id,
      actionId: webhook.actionId,
      url: webhook.url,
      secret: webhook.secret,
      subscribedEvents: webhook.subscribedEvents,
      isActive: webhook.isActive,
      createdAt: webhook.createdAt,
      updatedAt: webhook.updatedAt,
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
    subscribedEvents = _i1.ColumnString(
      'subscribedEvents',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    $_actionWebhooksActionId = _i1.ColumnInt(
      '_actionWebhooksActionId',
      this,
    );
  }

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnString url;

  late final _i1.ColumnString secret;

  late final _i1.ColumnString subscribedEvents;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt $_actionWebhooksActionId;

  @override
  List<_i1.Column> get columns => [
        id,
        actionId,
        url,
        secret,
        subscribedEvents,
        isActive,
        createdAt,
        updatedAt,
        $_actionWebhooksActionId,
      ];

  @override
  List<_i1.Column> get managedColumns => [
        id,
        actionId,
        url,
        secret,
        subscribedEvents,
        isActive,
        createdAt,
        updatedAt,
      ];
}

class WebhookInclude extends _i1.IncludeObject {
  WebhookInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

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
  }) async {
    return session.db.find<Webhook>(
      where: where?.call(Webhook.t),
      orderBy: orderBy?.call(Webhook.t),
      orderByList: orderByList?.call(Webhook.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
  }) async {
    return session.db.findFirstRow<Webhook>(
      where: where?.call(Webhook.t),
      orderBy: orderBy?.call(Webhook.t),
      orderByList: orderByList?.call(Webhook.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Webhook] by its [id] or null if no such row exists.
  Future<Webhook?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Webhook>(
      id,
      transaction: transaction,
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

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

abstract class VerificationAttempt
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  VerificationAttempt._({
    this.id,
    required this.actionId,
    required this.userId,
    required this.status,
    required this.startedAt,
    this.lastUpdatedAt,
    this.stepProgress,
    this.errorMessage,
  });

  factory VerificationAttempt({
    int? id,
    required int actionId,
    required String userId,
    required String status,
    required DateTime startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  }) = _VerificationAttemptImpl;

  factory VerificationAttempt.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationAttempt(
      id: jsonSerialization['id'] as int?,
      actionId: jsonSerialization['actionId'] as int,
      userId: jsonSerialization['userId'] as String,
      status: jsonSerialization['status'] as String,
      startedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      lastUpdatedAt: jsonSerialization['lastUpdatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastUpdatedAt']),
      stepProgress: jsonSerialization['stepProgress'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  static final t = VerificationAttemptTable();

  static const db = VerificationAttemptRepository._();

  @override
  int? id;

  int actionId;

  String userId;

  String status;

  DateTime startedAt;

  DateTime? lastUpdatedAt;

  String? stepProgress;

  String? errorMessage;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationAttempt copyWith({
    int? id,
    int? actionId,
    String? userId,
    String? status,
    DateTime? startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'userId': userId,
      'status': status,
      'startedAt': startedAt.toJson(),
      if (lastUpdatedAt != null) 'lastUpdatedAt': lastUpdatedAt?.toJson(),
      if (stepProgress != null) 'stepProgress': stepProgress,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'actionId': actionId,
      'userId': userId,
      'status': status,
      'startedAt': startedAt.toJson(),
      if (lastUpdatedAt != null) 'lastUpdatedAt': lastUpdatedAt?.toJson(),
      if (stepProgress != null) 'stepProgress': stepProgress,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  static VerificationAttemptInclude include() {
    return VerificationAttemptInclude._();
  }

  static VerificationAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<VerificationAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationAttemptTable>? orderByList,
    VerificationAttemptInclude? include,
  }) {
    return VerificationAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VerificationAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationAttemptImpl extends VerificationAttempt {
  _VerificationAttemptImpl({
    int? id,
    required int actionId,
    required String userId,
    required String status,
    required DateTime startedAt,
    DateTime? lastUpdatedAt,
    String? stepProgress,
    String? errorMessage,
  }) : super._(
          id: id,
          actionId: actionId,
          userId: userId,
          status: status,
          startedAt: startedAt,
          lastUpdatedAt: lastUpdatedAt,
          stepProgress: stepProgress,
          errorMessage: errorMessage,
        );

  /// Returns a shallow copy of this [VerificationAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationAttempt copyWith({
    Object? id = _Undefined,
    int? actionId,
    String? userId,
    String? status,
    DateTime? startedAt,
    Object? lastUpdatedAt = _Undefined,
    Object? stepProgress = _Undefined,
    Object? errorMessage = _Undefined,
  }) {
    return VerificationAttempt(
      id: id is int? ? id : this.id,
      actionId: actionId ?? this.actionId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      lastUpdatedAt:
          lastUpdatedAt is DateTime? ? lastUpdatedAt : this.lastUpdatedAt,
      stepProgress: stepProgress is String? ? stepProgress : this.stepProgress,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
    );
  }
}

class VerificationAttemptTable extends _i1.Table<int> {
  VerificationAttemptTable({super.tableRelation})
      : super(tableName: 'verification_attempt') {
    actionId = _i1.ColumnInt(
      'actionId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
    );
    lastUpdatedAt = _i1.ColumnDateTime(
      'lastUpdatedAt',
      this,
    );
    stepProgress = _i1.ColumnString(
      'stepProgress',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
  }

  late final _i1.ColumnInt actionId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnDateTime lastUpdatedAt;

  late final _i1.ColumnString stepProgress;

  late final _i1.ColumnString errorMessage;

  @override
  List<_i1.Column> get columns => [
        id,
        actionId,
        userId,
        status,
        startedAt,
        lastUpdatedAt,
        stepProgress,
        errorMessage,
      ];
}

class VerificationAttemptInclude extends _i1.IncludeObject {
  VerificationAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => VerificationAttempt.t;
}

class VerificationAttemptIncludeList extends _i1.IncludeList {
  VerificationAttemptIncludeList._({
    _i1.WhereExpressionBuilder<VerificationAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VerificationAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => VerificationAttempt.t;
}

class VerificationAttemptRepository {
  const VerificationAttemptRepository._();

  /// Returns a list of [VerificationAttempt]s matching the given query parameters.
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
  Future<List<VerificationAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<VerificationAttempt>(
      where: where?.call(VerificationAttempt.t),
      orderBy: orderBy?.call(VerificationAttempt.t),
      orderByList: orderByList?.call(VerificationAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [VerificationAttempt] matching the given query parameters.
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
  Future<VerificationAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationAttemptTable>? where,
    int? offset,
    _i1.OrderByBuilder<VerificationAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<VerificationAttempt>(
      where: where?.call(VerificationAttempt.t),
      orderBy: orderBy?.call(VerificationAttempt.t),
      orderByList: orderByList?.call(VerificationAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [VerificationAttempt] by its [id] or null if no such row exists.
  Future<VerificationAttempt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<VerificationAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [VerificationAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [VerificationAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<VerificationAttempt>> insert(
    _i1.Session session,
    List<VerificationAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<VerificationAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [VerificationAttempt] and returns the inserted row.
  ///
  /// The returned [VerificationAttempt] will have its `id` field set.
  Future<VerificationAttempt> insertRow(
    _i1.Session session,
    VerificationAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VerificationAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VerificationAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VerificationAttempt>> update(
    _i1.Session session,
    List<VerificationAttempt> rows, {
    _i1.ColumnSelections<VerificationAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VerificationAttempt>(
      rows,
      columns: columns?.call(VerificationAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VerificationAttempt> updateRow(
    _i1.Session session,
    VerificationAttempt row, {
    _i1.ColumnSelections<VerificationAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VerificationAttempt>(
      row,
      columns: columns?.call(VerificationAttempt.t),
      transaction: transaction,
    );
  }

  /// Deletes all [VerificationAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VerificationAttempt>> delete(
    _i1.Session session,
    List<VerificationAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VerificationAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VerificationAttempt].
  Future<VerificationAttempt> deleteRow(
    _i1.Session session,
    VerificationAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VerificationAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VerificationAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<VerificationAttemptTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VerificationAttempt>(
      where: where(VerificationAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationAttemptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VerificationAttempt>(
      where: where?.call(VerificationAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

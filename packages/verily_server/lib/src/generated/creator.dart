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

abstract class Creator implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  Creator._({
    this.id,
    required this.userInfoId,
  });

  factory Creator({
    int? id,
    required int userInfoId,
  }) = _CreatorImpl;

  factory Creator.fromJson(Map<String, dynamic> jsonSerialization) {
    return Creator(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
    );
  }

  static final t = CreatorTable();

  static const db = CreatorRepository._();

  @override
  int? id;

  int userInfoId;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [Creator]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Creator copyWith({
    int? id,
    int? userInfoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
    };
  }

  static CreatorInclude include() {
    return CreatorInclude._();
  }

  static CreatorIncludeList includeList({
    _i1.WhereExpressionBuilder<CreatorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatorTable>? orderByList,
    CreatorInclude? include,
  }) {
    return CreatorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Creator.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Creator.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreatorImpl extends Creator {
  _CreatorImpl({
    int? id,
    required int userInfoId,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
        );

  /// Returns a shallow copy of this [Creator]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Creator copyWith({
    Object? id = _Undefined,
    int? userInfoId,
  }) {
    return Creator(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
    );
  }
}

class CreatorTable extends _i1.Table<int> {
  CreatorTable({super.tableRelation}) : super(tableName: 'creator') {
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
  }

  late final _i1.ColumnInt userInfoId;

  @override
  List<_i1.Column> get columns => [
        id,
        userInfoId,
      ];
}

class CreatorInclude extends _i1.IncludeObject {
  CreatorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => Creator.t;
}

class CreatorIncludeList extends _i1.IncludeList {
  CreatorIncludeList._({
    _i1.WhereExpressionBuilder<CreatorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Creator.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => Creator.t;
}

class CreatorRepository {
  const CreatorRepository._();

  /// Returns a list of [Creator]s matching the given query parameters.
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
  Future<List<Creator>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Creator>(
      where: where?.call(Creator.t),
      orderBy: orderBy?.call(Creator.t),
      orderByList: orderByList?.call(Creator.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Creator] matching the given query parameters.
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
  Future<Creator?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatorTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreatorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Creator>(
      where: where?.call(Creator.t),
      orderBy: orderBy?.call(Creator.t),
      orderByList: orderByList?.call(Creator.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Creator] by its [id] or null if no such row exists.
  Future<Creator?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Creator>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Creator]s in the list and returns the inserted rows.
  ///
  /// The returned [Creator]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Creator>> insert(
    _i1.Session session,
    List<Creator> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Creator>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Creator] and returns the inserted row.
  ///
  /// The returned [Creator] will have its `id` field set.
  Future<Creator> insertRow(
    _i1.Session session,
    Creator row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Creator>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Creator]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Creator>> update(
    _i1.Session session,
    List<Creator> rows, {
    _i1.ColumnSelections<CreatorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Creator>(
      rows,
      columns: columns?.call(Creator.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Creator]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Creator> updateRow(
    _i1.Session session,
    Creator row, {
    _i1.ColumnSelections<CreatorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Creator>(
      row,
      columns: columns?.call(Creator.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Creator]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Creator>> delete(
    _i1.Session session,
    List<Creator> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Creator>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Creator].
  Future<Creator> deleteRow(
    _i1.Session session,
    Creator row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Creator>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Creator>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreatorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Creator>(
      where: where(Creator.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Creator>(
      where: where?.call(Creator.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

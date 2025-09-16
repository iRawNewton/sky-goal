import 'package:hive/hive.dart';

part 'txn_model.g.dart';


@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category;

  @HiveField(3)
  String description;

  @HiveField(4)
  String wallet;

  @HiveField(5)
  String? attachmentPath;

  @HiveField(6)
  String type;

  @HiveField(7)
  DateTime date;

  @HiveField(8)
  int walletId;

  @HiveField(9)
  DateTime createdAt;

  TransactionModel({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.wallet,
    this.attachmentPath,
    required this.type,
    required this.date,
    required this.walletId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

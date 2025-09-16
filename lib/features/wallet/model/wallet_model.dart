import 'package:hive/hive.dart';

part 'wallet_model.g.dart';


@HiveType(typeId: 2)
class WalletModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String accountType; // e.g. "savings", "credit", etc.

  @HiveField(3)
  double balance;

  WalletModel({
    this.id,
    required this.name,
    required this.accountType,
    this.balance = 0,
  });
}

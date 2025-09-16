import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  double accountBalance;

  @HiveField(5)
  double walletBalance;

  UserModel({this.id, required this.name, required this.email, required this.password, this.accountBalance = 0.0, this.walletBalance = 0.0});

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as int?,
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    password: map['password'] ?? '',
    accountBalance: (map['accountBalance'] ?? 0).toDouble(),
    walletBalance: (map['walletBalance'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'accountBalance': accountBalance,
    'walletBalance': walletBalance,
  };

  factory UserModel.empty() => UserModel(id: null, name: '', email: '', password: '');
}

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../features/authentication/model/user_model.dart';
import '../features/transaction/model/txn_model.dart';
import '../features/wallet/model/wallet_model.dart';

class HiveService {
  static const String userBoxName = 'usersBox';
  static const String walletBoxName = 'walletsBox';
  static const String transactionBoxName = 'transactionsBox';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());

    await Hive.openBox<UserModel>(userBoxName);
    await Hive.openBox<WalletModel>(walletBoxName);
    await Hive.openBox<TransactionModel>(transactionBoxName);
  }

  // ---------------- USERS ----------------
  Future<int> createUser(UserModel user) async {
    final box = Hive.box<UserModel>(userBoxName);
    final id = await box.add(user);
    user.id = id;
    await box.put(id, user);
    return id;
  }

  UserModel? getUserByEmail(String email) {
    final box = Hive.box<UserModel>(userBoxName);
    return box.values.firstWhere(
      (u) => u.email == email,
      orElse: () => UserModel.empty(),
    );
  }

  List<UserModel> getAllUsers() => Hive.box<UserModel>(userBoxName).values.toList();

  Future<void> updateUser(UserModel user) async {
    if (user.id != null) {
      await Hive.box<UserModel>(userBoxName).put(user.id, user);
    }
  }

  Future<void> deleteUser(int id) async {
    await Hive.box<UserModel>(userBoxName).delete(id);
  }

  // ---------------- WALLETS ----------------
  Future<int> createWallet(WalletModel wallet) async {
    final box = Hive.box<WalletModel>(walletBoxName);
    final id = await box.add(wallet);
    wallet.id = id;
    await box.put(id, wallet);
    return id;
  }

  List<WalletModel> getAllWallets() => Hive.box<WalletModel>(walletBoxName).values.toList();

  WalletModel? getWalletById(int id) {
    return Hive.box<WalletModel>(walletBoxName).get(id);
  }

  Future<void> updateWallet(WalletModel wallet) async {
    if (wallet.id != null) {
      await Hive.box<WalletModel>(walletBoxName).put(wallet.id, wallet);
    }
  }

  Future<void> deleteWallet(int id) async {
    await Hive.box<WalletModel>(walletBoxName).delete(id);
  }

  // ---------------- TRANSACTIONS ----------------
  Future<int> createTransaction(TransactionModel txn) async {
    final txnBox = Hive.box<TransactionModel>(transactionBoxName);
    final walletBox = Hive.box<WalletModel>(walletBoxName);

    final id = await txnBox.add(txn);
    txn.id = id;
    await txnBox.put(id, txn);

    // Update wallet balance
    final wallet = walletBox.get(txn.walletId);
    if (wallet != null) {
      wallet.balance += txn.amount;
      await walletBox.put(wallet.id, wallet);
    }

    return id;
  }

  TransactionModel? getTransactionById(int id) {
    return Hive.box<TransactionModel>(transactionBoxName).get(id);
  }

  List<TransactionModel> getTransactions() {
    return Hive.box<TransactionModel>(transactionBoxName).values.toList();
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    if (txn.id != null) {
      await Hive.box<TransactionModel>(transactionBoxName).put(txn.id, txn);
    }
  }

  Future<void> deleteTransaction(int id) async {
    await Hive.box<TransactionModel>(transactionBoxName).delete(id);
  }
}

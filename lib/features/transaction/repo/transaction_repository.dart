import '../../../services/hive_service.dart';
import '../model/txn_model.dart';

class TransactionRepository {
  final HiveService _hiveService;

  TransactionRepository(this._hiveService);

  Future<int> createTransaction(TransactionModel txn) => _hiveService.createTransaction(txn);

  TransactionModel? getTransactionById(int id) => _hiveService.getTransactionById(id);

  List<TransactionModel> getTransactions() => _hiveService.getTransactions();

  Future<void> updateTransaction(TransactionModel txn) => _hiveService.updateTransaction(txn);

  Future<void> deleteTransaction(int id) => _hiveService.deleteTransaction(id);
}

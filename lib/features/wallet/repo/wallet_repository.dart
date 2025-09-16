import '../../../services/hive_service.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final HiveService _hiveService;

  WalletRepository(this._hiveService);

  Future<int> createWallet(WalletModel wallet) => _hiveService.createWallet(wallet);

  List<WalletModel> getAllWallets() => _hiveService.getAllWallets();

  WalletModel? getWalletById(int id) => _hiveService.getWalletById(id);

  Future<void> updateWallet(WalletModel wallet) => _hiveService.updateWallet(wallet);

  Future<void> deleteWallet(int id) => _hiveService.deleteWallet(id);
}

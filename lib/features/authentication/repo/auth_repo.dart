import '../../../services/hive_service.dart';
import '../model/user_model.dart';

class UserRepository {
  final HiveService _hiveService;

  UserRepository(this._hiveService);

  Future<int> createUser(UserModel user) => _hiveService.createUser(user);

  UserModel? getUserByEmail(String email) => _hiveService.getUserByEmail(email);

  List<UserModel> getAllUsers() => _hiveService.getAllUsers();

  Future<void> updateUser(UserModel user) => _hiveService.updateUser(user);

  Future<void> deleteUser(int id) => _hiveService.deleteUser(id);
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../data/users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UsersRepository(apiClient);
});

class UsersNotifier extends AsyncNotifier<List<UserModel>> {
  @override
  FutureOr<List<UserModel>> build() async {
    final repository = ref.watch(usersRepositoryProvider);
    return await repository.getUsers();
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    final repository = ref.read(usersRepositoryProvider);
    final newUser = await repository.createUser(data);
    state = AsyncData([...?state.value, newUser]);
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<UserModel>>(() {
  return UsersNotifier();
});

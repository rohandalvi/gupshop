import 'package:firestore_service/firestore_service.dart';
import 'package:gupshop/service/firestore_path.dart';
import 'package:gupshop/service/login_auth_service.dart';
import 'package:riverpod/all.dart';

class FirestoreDatabase {

  final databaseProvider = Provider<FirestoreDatabase>((ref) {
    final auth = ref.watch(authStateChangesProvider);
    if(auth.data?.value?.uid !=null) {
      return FirestoreDatabase();
    }
    return null;
  });

  final _service = FirestoreService.instance;

  Future<void> setUser(AppUser appUser) => _service.setData(
      path: FirestorePath.user(appUser.phoneNumber), data: appUser.toMap());
}

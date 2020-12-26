import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/all.dart';

class AppUser {
  const AppUser({
    this.uid,
    this.phoneNumber,
    this.name

  }) : assert(uid != null, 'User can only be created with a non-null id');

  final String uid;
  final String phoneNumber;
  final String name;

  factory AppUser.fromFirebaseUser(User user) {
    if (user == null) return null;
    return AppUser(uid: user.uid, phoneNumber: user.phoneNumber);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber
    };
  }

  @override
  String toString() => 'uid: $uid, phoneNumber: $phoneNumber';
}

final loginAuthServiceProvider = Provider<LoginAuthService>((ref) => LoginAuthService());
final authStateChangesProvider = StreamProvider<AppUser>((ref) => ref.watch(loginAuthServiceProvider).authStateChanges());

class LoginAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<AppUser> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) =>
        AppUser.fromFirebaseUser(user));
  }

  // Future<AppUser> signInWithPhoneNumber(phoneNumber) {
  //
  //   _signIn(AuthCredential authCreds) {
  //     FirebaseAuth.instance.signInWithCredential(authCreds);
  //   }
  //
  //   final PhoneVerificationCompleted verified = (AuthCredential authResult) {
  //     return _signIn(authResult);
  //   };
  //
  //   final PhoneVerificationFailed verificationfailed = (FirebaseAuthException authException) {
  //     print("Firebase auth verification failed");
  //   };
  //
  // }

  Future<ConfirmationResult> sendCode(phoneNumber, appVerifier) {
    return _firebaseAuth.signInWithPhoneNumber(phoneNumber, appVerifier);
  }

  Future<AppUser> signInWithPhoneNumber(ConfirmationResult confirmationResult,
      String smsCode) async {
    UserCredential userCredential = await confirmationResult.confirm(smsCode);
    return AppUser.fromFirebaseUser(userCredential.user);
  }

}
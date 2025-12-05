import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(String name, String email, String password) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user!.updateDisplayName(name);
    await userCredential.user!.reload();
  }
}

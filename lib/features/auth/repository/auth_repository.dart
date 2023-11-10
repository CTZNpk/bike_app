import 'package:bike_app/shared/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class AuthRepository {
  AuthRepository({required this.auth, required this.ref});

  final FirebaseAuth auth;
  AuthSignIn? signIn;
  ProviderRef ref;

  Future creatingUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    signIn = _CreateUserWithEmailAndPassword(
        auth: auth, email: email, password: password);
    await signIn?.signingIn(context: context);
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    signIn = _SignInUserWithEmailAndPassword(
        auth: auth, email: email, password: password);
    await signIn?.signingIn(context: context);
  }

  Future signingInUserWithGoogle({
    required BuildContext context,
  }) async {
    signIn = _SignInUserWithGoogle(auth: auth);
    await signIn?.signingIn(context: context);
  }

  Future signingOut() async {
    await auth.signOut();
  }
}

abstract class AuthSignIn {
  AuthSignIn({
    required this.auth,
  });

  final FirebaseAuth auth;

  Future signingIn({required BuildContext context});
  Future tryAndCatchBlock(Function function, BuildContext context) async {
    try {
      await function();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      throw e.toString();
    }
  }
}

class _CreateUserWithEmailAndPassword extends AuthSignIn {
  _CreateUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn({required BuildContext context}) async {
    await tryAndCatchBlock(_creatingUser, context);
  }

  Future _creatingUser() async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}

class _SignInUserWithEmailAndPassword extends AuthSignIn {
  _SignInUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn({required BuildContext context}) async {
    await tryAndCatchBlock(_signInUser, context);
  }

  Future _signInUser() async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
}

class _SignInUserWithGoogle extends AuthSignIn {
  _SignInUserWithGoogle({
    required super.auth,
  });

  @override
  Future signingIn({required BuildContext context}) async {
    await tryAndCatchBlock(signInUser, context);
  }

  Future signInUser() async {
    final gUser = await _displayingSignInPage();
    final gAuth = await _obtainingDetails(gUser);
    await _signingInWithCredentials(_creatingCredentials(gAuth));
  }


  Future<GoogleSignInAccount?> _displayingSignInPage() async {
    return await GoogleSignIn().signIn();
    
  }

  Future<GoogleSignInAuthentication> _obtainingDetails(
      GoogleSignInAccount? gUser) async {
    return await gUser!.authentication;
  }

  _creatingCredentials(GoogleSignInAuthentication gAuth) {
    return GoogleAuthProvider.credential(
        idToken: gAuth.idToken, accessToken: gAuth.accessToken);
  }

  _signingInWithCredentials(AuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

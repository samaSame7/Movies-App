import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../user_dm.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    emit(RegisterLoading());

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "id": credential.user!.uid,
        "name": name,
        "email": email,
        "phone_number": phone,
        "profile_photo": avatar,
      });

      UserDM.currentUser = UserDM(
        id: credential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phone,
        profilePhoto: avatar,
      );

      emit(RegisterSuccess(credential.user!));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = e.message ?? "Something went wrong. Try again later";
      }
      emit(RegisterError(message));
    } catch (e) {
      emit(RegisterError("Something went wrong. Try again later"));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_assets/app_assets.dart';
import '../../auth/firebase_utility.dart';
import '../../auth/user_dm.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  String selectedAvatar = UserDM.currentUser!.profilePhoto;
  List<String> avatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9
  ];

  Future<void> updateUserData({
    required String name,
    required String phone,
    required String avatar,
  }) async {

    emit(ProfileLoading());

    try {

      await updateUserProfile(userId: UserDM.currentUser!.id, name: name, phone: phone, avatar: avatar);

      UserDM.currentUser!.name = name;
      UserDM.currentUser!.phoneNumber = phone;
      UserDM.currentUser!.profilePhoto = avatar;

      emit(ProfileSuccess());

    } catch (e) {

      emit(ProfileError(e.toString()));

    }
  }

  void changeAvatar(String avatar) {
    selectedAvatar = avatar;
    emit(AvatarChanged());
  }
}
class UserDM {
  static const collectionName = "users";
  static UserDM? currentUser;
  String id;
  String email;
  String name;
  String phoneNumber;
   int? wishListCount;
   int? historyCount;
   String profilePhoto;

  UserDM({
    required this.profilePhoto,
     this.wishListCount,
     this.historyCount,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  static UserDM fromJson(Map<String, dynamic> json) {
    return UserDM(

        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
      wishListCount: json["wish_list_count"],
      historyCount: json["history_count"],
        profilePhoto: json["profile_photo"]
     );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "wish_list_count":wishListCount,
      "history_count":historyCount,
      "profile_photo":profilePhoto
    };
  }
}

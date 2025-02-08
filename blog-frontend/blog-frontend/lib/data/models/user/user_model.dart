class UserModel {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? avatar;
  String? level;
  String? id;
  String? createdOn;
  String? updatedOn;

  UserModel({
    this.sId,
    this.fullName,
    this.email,
    this.password,
    this.avatar,
    this.level,
    this.id,
    this.createdOn,
    this.updatedOn,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    level = json['level'];
    id = json['id'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['level'] = this.level;
    data['id'] = this.id;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}

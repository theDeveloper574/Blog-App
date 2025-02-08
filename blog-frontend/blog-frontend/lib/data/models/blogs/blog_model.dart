import 'package:blog/data/models/user/user_model.dart';
import 'package:equatable/equatable.dart';

class BlogModel extends Equatable {
  String? sId;
  String? title;
  String? content;
  UserModel? user;
  String? createdOn;
  String? updatedOn;
  List<Replies>? replies;
  bool isFavorite = false;

  BlogModel({
    this.sId,
    this.title,
    this.content,
    this.user,
    this.createdOn,
    this.updatedOn,
    this.replies,
  });

  BlogModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    // user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    user = UserModel.fromJson(json['user']);
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    } else {
      replies = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['content'] = this.content;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  BlogModel copyWith({
    String? sId,
    String? title,
    String? content,
    UserModel? user,
    String? createdOn,
    String? updatedOn,
    List<Replies>? replies,
  }) {
    return BlogModel(
      sId: sId ?? this.sId,
      title: title ?? this.title,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      user: user ?? this.user,
      content: content ?? this.content,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [sId, isFavorite];
}

class Replies {
  UserModel? user;
  String? replyCon;
  DateTime? createdOn;
  String? sId;

  Replies({this.user, this.replyCon, this.createdOn, this.sId});

  Replies.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    replyCon = json['replyCon'];
    createdOn = DateTime.tryParse(json['createdOn']);
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['replyCon'] = this.replyCon;
    data['createdOn'] = this.createdOn?.toIso8601String();
    data['_id'] = this.sId;
    return data;
  }
}

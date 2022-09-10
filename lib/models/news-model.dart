class News {
  int? id;
  String? title;
  String? tags;
  int? tabUserId;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? filename;
  int? status;
  String? slug;
  String? firstName;
  String? lastName;

  News(
      {this.id,
      this.title,
      this.tags,
      this.tabUserId,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.filename,
      this.status,
      this.slug,
      this.firstName,
      this.lastName});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'];
    tabUserId = json['tab_user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    filename = json['filename'];
    status = json['status'];
    slug = json['slug'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['tab_user_id'] = this.tabUserId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['filename'] = this.filename;
    data['status'] = this.status;
    data['slug'] = this.slug;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}

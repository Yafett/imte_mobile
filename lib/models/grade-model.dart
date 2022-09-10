class Grade {
  int? id;
  String? grade;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;

  Grade(
      {this.id,
      this.grade,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt});

  Grade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

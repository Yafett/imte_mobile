class Gallery {
  int? id;
  String? name;
  String? url;
  String? src;
  String? alt;
  String? createdAt;
  String? updatedAt;

  Gallery(
      {this.id,
      this.name,
      this.url,
      this.src,
      this.alt,
      this.createdAt,
      this.updatedAt});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    src = json['src'];
    alt = json['alt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['src'] = this.src;
    data['alt'] = this.alt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Instrument {
  int? id;
  String? major;
  String? url;
  String? status;
  String? idx;
  String? createdAt;
  String? updatedAt;

  Instrument(
      {this.id,
      this.major,
      this.url,
      this.status,
      this.idx,
      this.createdAt,
      this.updatedAt});

  Instrument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    major = json['major'];
    url = json['url'];
    status = json['status'].toString();
    status = json['idx'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['major'] = this.major;
    data['url'] = this.url;
    data['status'] = this.status;
    data['idx'] = this.idx;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

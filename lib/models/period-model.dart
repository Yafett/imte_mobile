class Period {
  int? id;
  String? periodName;
  int? price;
  String? startDate;
  String? endDate;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? mulai;
  String? selesai;

  Period(
      {this.id,
      this.periodName,
      this.price,
      this.startDate,
      this.endDate,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.mulai,
      this.selesai});

  Period.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    periodName = json['period_name'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mulai = json['mulai'];
    selesai = json['selesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['period_name'] = this.periodName;
    data['price'] = this.price;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mulai'] = this.mulai;
    data['selesai'] = this.selesai;
    return data;
  }
}

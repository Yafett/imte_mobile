class Instructor {
  int? id;
  int? usersId;
  int? tabUnitId;
  String? mobile;
  String? mobileVerifiedAt;
  String? type;
  String? gender;
  String? firstName;
  String? lastName;
  String? suffix;
  String? place;
  String? dateOfBirth;
  String? address;
  String? city;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? wali;
  String? noWali;
  int? examiner;
  String? photoLocation;
  String? wa;
  String? ttd;
  String? unitName;

  Instructor(
      {this.id,
      this.usersId,
      this.tabUnitId,
      this.mobile,
      this.mobileVerifiedAt,
      this.type,
      this.gender,
      this.firstName,
      this.lastName,
      this.suffix,
      this.place,
      this.dateOfBirth,
      this.address,
      this.city,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.wali,
      this.noWali,
      this.examiner,
      this.photoLocation,
      this.wa,
      this.ttd,
      this.unitName});

  Instructor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    tabUnitId = json['tab_unit_id'];
    mobile = json['mobile'];
    mobileVerifiedAt = json['mobile_verified_at'];
    type = json['type'];
    gender = json['gender'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    suffix = json['suffix'];
    place = json['place'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    city = json['city'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    wali = json['wali'];
    noWali = json['no_wali'];
    examiner = json['examiner'];
    photoLocation = json['photo_location'];
    wa = json['wa'];
    ttd = json['ttd'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['tab_unit_id'] = this.tabUnitId;
    data['mobile'] = this.mobile;
    data['mobile_verified_at'] = this.mobileVerifiedAt;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['suffix'] = this.suffix;
    data['place'] = this.place;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['wali'] = this.wali;
    data['no_wali'] = this.noWali;
    data['examiner'] = this.examiner;
    data['photo_location'] = this.photoLocation;
    data['wa'] = this.wa;
    data['ttd'] = this.ttd;
    data['unit_name'] = this.unitName;
    return data;
  }
}

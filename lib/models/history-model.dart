class History {
  int? id;
  int? tabUserId;
  int? tabUnitId;
  int? tabPeriodId;
  int? tabMajorId;
  int? tabGradeId;
  String? paymentUrl;
  int? enrollStatus;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? filename;
  int? teacherId;
  String? activityStatus;
  String? songs;
  bool? active;
  String? activityFormat;
  Major? major;
  Period? period;
  Grade? grade;
  HistoryTeacher? teacher;
  String? result;
  Schedule? schedule;

  History(
      {this.id,
      this.tabUserId,
      this.tabUnitId,
      this.tabPeriodId,
      this.tabMajorId,
      this.tabGradeId,
      this.paymentUrl,
      this.enrollStatus,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.filename,
      this.teacherId,
      this.activityStatus,
      this.songs,
      this.active,
      this.activityFormat,
      this.major,
      this.period,
      this.grade,
      this.teacher,
      this.result,
      this.schedule});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tabUserId = json['tab_user_id'];
    tabUnitId = json['tab_unit_id'];
    tabPeriodId = json['tab_period_id'];
    tabMajorId = json['tab_major_id'];
    tabGradeId = json['tab_grade_id'];
    paymentUrl = json['payment_url'];
    enrollStatus = json['enroll_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    filename = json['filename'];
    teacherId = json['teacher_id'];
    activityStatus = json['activity_status'];
    songs = json['songs'];
    active = json['active'];
    activityFormat = json['activity_format'];
    major = json['major'] != null ? new Major.fromJson(json['major']) : null;
    period =
        json['period'] != null ? new Period.fromJson(json['period']) : null;
    grade = json['grade'] != null ? new Grade.fromJson(json['grade']) : null;
    teacher =
        json['teacher'] != null ? new HistoryTeacher.fromJson(json['teacher']) : null;
    result = json['result'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tab_user_id'] = this.tabUserId;
    data['tab_unit_id'] = this.tabUnitId;
    data['tab_period_id'] = this.tabPeriodId;
    data['tab_major_id'] = this.tabMajorId;
    data['tab_grade_id'] = this.tabGradeId;
    data['payment_url'] = this.paymentUrl;
    data['enroll_status'] = this.enrollStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['filename'] = this.filename;
    data['teacher_id'] = this.teacherId;
    data['activity_status'] = this.activityStatus;
    data['songs'] = this.songs;
    data['active'] = this.active;
    data['activity_format'] = this.activityFormat;
    if (this.major != null) {
      data['major'] = this.major!.toJson();
    }
    if (this.period != null) {
      data['period'] = this.period!.toJson();
    }
    if (this.grade != null) {
      data['grade'] = this.grade!.toJson();
    }
    if (this.teacher != null) {
      data['teacher'] = this.teacher!.toJson();
    }
    data['result'] = this.result;
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.toJson();
    }
    return data;
  }
}

class Major {
  int? id;
  String? major;

  Major({this.id, this.major});

  Major.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    major = json['major'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['major'] = this.major;
    return data;
  }
}

class Period {
  int? id;
  String? periodName;

  Period({this.id, this.periodName});

  Period.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    periodName = json['period_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['period_name'] = this.periodName;
    return data;
  }
}

class Grade {
  int? id;
  String? grade;

  Grade({this.id, this.grade});

  Grade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    return data;
  }
}

class HistoryTeacher {
  int? id;
  String? firstName;
  String? lastName;

  HistoryTeacher({this.id, this.firstName, this.lastName});

  HistoryTeacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}

class Schedule {
  int? id;
  int? enrollId;
  String? date;
  String? practical;
  String? insKnowledge;
  String? createdAt;
  String? updatedAt;
  String? practicalRoom;
  String? bahasa;
  String? lokasi;

  Schedule(
      {this.id,
      this.enrollId,
      this.date,
      this.practical,
      this.insKnowledge,
      this.createdAt,
      this.updatedAt,
      this.practicalRoom,
      this.bahasa,
      this.lokasi});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enrollId = json['enroll_id'];
    date = json['date'];
    practical = json['practical'];
    insKnowledge = json['ins_knowledge'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    practicalRoom = json['practical_room'];
    bahasa = json['bahasa'];
    lokasi = json['lokasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enroll_id'] = this.enrollId;
    data['date'] = this.date;
    data['practical'] = this.practical;
    data['ins_knowledge'] = this.insKnowledge;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['practical_room'] = this.practicalRoom;
    data['bahasa'] = this.bahasa;
    data['lokasi'] = this.lokasi;
    return data;
  }
}

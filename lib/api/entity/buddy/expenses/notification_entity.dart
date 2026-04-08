class NotificationEntity {
  String? companyId;
  String? mobileNo;
  String? fcmToken;
  String? title;
  String? body;
  String? notificationMobNo;
  String? readStatus;
  String? time;
  String? moduleType;
  String? uniqueId;
  String? unreadCount;
  String? date;
  String? userName;
  String? status;

  String? notificationEmailId;
  NotificationEntity(
      {this.companyId,
      this.body,
      this.fcmToken,
      this.mobileNo,
      this.title,
      this.moduleType,
      this.readStatus,
      this.notificationMobNo,
      this.time,
      this.uniqueId,
      this.unreadCount,
      this.date,
      this.status,
      this.userName,
      this.notificationEmailId});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];

    body = json['body'];
    fcmToken = json['fcm_token'];
    mobileNo = json['mobile_no'];

    title = json['title'];
    readStatus = json['read_status'];

    time = json['time'];
    moduleType = json['module_type'];
    uniqueId = json['unique_id'];
    unreadCount = json['unread_count'];
    date = json['date'];
    userName = json['user_name'];
    status = json['status'];
    notificationMobNo = json['notification_mob_no'];
    notificationEmailId = json['notification_email_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }

    if (body != null) {
      data['body'] = body;
    }
    if (fcmToken != null) {
      data['fcm_token'] = fcmToken;
    }
    if (mobileNo != null) {
      data['mobile_no'] = mobileNo;
    }
    if (title != null) {
      data['title'] = title;
    }

    if (notificationMobNo != null) {
      data['notification_mob_no'] = notificationMobNo;
    }
    if (moduleType != null) {
      data['module_type'] = moduleType;
    }
    if (notificationEmailId != null) {
      data['notification_email_id'] = notificationEmailId;
    }
    if (uniqueId != null) {
      data['unique_id'] = uniqueId;
    }
    return data;
  }
}

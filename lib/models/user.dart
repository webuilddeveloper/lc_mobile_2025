class LoginRegister {
  String status;
  String message;
  User? objectData; // ต้องทำให้ objectData เป็น nullable

  LoginRegister({
    required this.status,
    required this.message,
    this.objectData, // ไม่ required เพราะอาจเป็น null
  });

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    var map = <String, dynamic>{};
    map['status'] = loginRegister.status;
    map['message'] = loginRegister.message;
    if (loginRegister.objectData != null) {
      map['objectData'] = User.toMap(loginRegister);
    }
    return map;
  }

  LoginRegister.map(dynamic obj)
      : status = obj["status"] as String,
        message = obj["message"] as String {
    if (obj['objectData'] != null) {
      objectData = User.map(obj['objectData']);
    }
  }

  factory LoginRegister.fromJson(dynamic json) {
    if (json['objectData'] != null && json['objectData'] != '') {
      return LoginRegister(
        status: json['status'] as String,
        message: json['message'] as String,
        objectData: User.fromJson(json['objectData']),
      );
    } else {
      return LoginRegister(
        status: json['status'] as String,
        message: json['message'] as String,
      );
    }
  }
}

class User {
  String prefixName;
  String firstName;
  String lastName;
  String email;
  String category;
  String code;
  String username;
  String password;
  bool isActive;
  String status;
  String createBy;
  String createDate;
  String imageUrl;
  String updateBy;
  String updateDate;
  String birthDay;
  String phone;
  String facebookID;
  String googleID;
  String lineID;
  String appleID;
  String line;
  String sex;
  String address;
  String tambonCode;
  String tambon;
  String amphoeCode;
  String amphoe;
  String provinceCode;
  String province;
  String postnoCode;
  String postno;
  String job;
  String idcard;
  String countUnit;
  String lv0;
  String lv1;
  String lv2;
  String lv3;
  String lv4;
  String lv5;
  String linkAccount;
  String officerCode;

  static User map(dynamic json) {
    return User(
      prefixName: json['prefixName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      category: json['category'] as String? ?? '',
      code: json['code'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      createBy: json['createBy'] as String? ?? '',
      createDate: json['createDate'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      updateBy: json['updateBy'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      birthDay: json['birthDay'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      facebookID: json['facebookID'] as String? ?? '',
      googleID: json['googleID'] as String? ?? '',
      lineID: json['lineID'] as String? ?? '',
      appleID: json['appleID'] as String? ?? '',
      line: json['line'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      address: json['address'] as String? ?? '',
      tambonCode: json['tambonCode'] as String? ?? '',
      tambon: json['tambon'] as String? ?? '',
      amphoeCode: json['amphoeCode'] as String? ?? '',
      amphoe: json['amphoe'] as String? ?? '',
      provinceCode: json['provinceCode'] as String? ?? '',
      province: json['province'] as String? ?? '',
      postnoCode: json['postnoCode'] as String? ?? '',
      postno: json['postno'] as String? ?? '',
      job: json['job'] as String? ?? '',
      idcard: json['idcard'] as String? ?? '',
      countUnit: json['countUnit'] as String? ?? '',
      lv0: json['lv0'] as String? ?? '',
      lv1: json['lv1'] as String? ?? '',
      lv2: json['lv2'] as String? ?? '',
      lv3: json['lv3'] as String? ?? '',
      lv4: json['lv4'] as String? ?? '',
      lv5: json['lv5'] as String? ?? '',
      linkAccount: json['linkAccount'] as String? ?? '',
      officerCode: json['officerCode'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toMap(LoginRegister loginRegister) {
    if (loginRegister.objectData == null) {
      return {};
    }

    var map = <String, dynamic>{};
    map['prefixName'] = loginRegister.objectData!.prefixName;
    map['firstName'] = loginRegister.objectData!.firstName;
    map['lastName'] = loginRegister.objectData!.lastName;
    map['email'] = loginRegister.objectData!.email;
    map['category'] = loginRegister.objectData!.category;
    map['code'] = loginRegister.objectData!.code;
    map['username'] = loginRegister.objectData!.username;
    map['password'] = loginRegister.objectData!.password;
    map['isActive'] = loginRegister.objectData!.isActive;
    map['status'] = loginRegister.objectData!.status;
    map['createBy'] = loginRegister.objectData!.createBy;
    map['createDate'] = loginRegister.objectData!.createDate;
    map['imageUrl'] = loginRegister.objectData!.imageUrl;
    map['updateBy'] = loginRegister.objectData!.updateBy;
    map['updateDate'] = loginRegister.objectData!.updateDate;
    map['birthDay'] = loginRegister.objectData!.birthDay;
    map['phone'] = loginRegister.objectData!.phone;
    map['facebookID'] = loginRegister.objectData!.facebookID;
    map['googleID'] = loginRegister.objectData!.googleID;
    map['lineID'] = loginRegister.objectData!.lineID;
    map['appleID'] = loginRegister.objectData!.appleID;
    map['line'] = loginRegister.objectData!.line;
    map['sex'] = loginRegister.objectData!.sex;
    map['address'] = loginRegister.objectData!.address;
    map['tambonCode'] = loginRegister.objectData!.tambonCode;
    map['tambon'] = loginRegister.objectData!.tambon;
    map['amphoeCode'] = loginRegister.objectData!.amphoeCode;
    map['amphoe'] = loginRegister.objectData!.amphoe;
    map['provinceCode'] = loginRegister.objectData!.provinceCode;
    map['province'] = loginRegister.objectData!.province;
    map['postnoCode'] = loginRegister.objectData!.postnoCode;
    map['postno'] = loginRegister.objectData!.postno;
    map['job'] = loginRegister.objectData!.job;
    map['idcard'] = loginRegister.objectData!.idcard;
    map['countUnit'] = loginRegister.objectData!.countUnit;
    map['lv0'] = loginRegister.objectData!.lv0;
    map['lv1'] = loginRegister.objectData!.lv1;
    map['lv2'] = loginRegister.objectData!.lv2;
    map['lv3'] = loginRegister.objectData!.lv3;
    map['lv4'] = loginRegister.objectData!.lv4;
    map['lv5'] = loginRegister.objectData!.lv5;
    map['linkAccount'] = loginRegister.objectData!.linkAccount;
    map['officerCode'] = loginRegister.objectData!.officerCode;
    return map;
  }

  factory User.fromJson(dynamic json) {
    return User(
      prefixName: json['prefixName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      category: json['category'] as String? ?? '',
      code: json['code'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      createBy: json['createBy'] as String? ?? '',
      createDate: json['createDate'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      updateBy: json['updateBy'] as String? ?? '',
      updateDate: json['updateDate'] as String? ?? '',
      birthDay: json['birthDay'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      facebookID: json['facebookID'] as String? ?? '',
      googleID: json['googleID'] as String? ?? '',
      lineID: json['lineID'] as String? ?? '',
      appleID: json['appleID'] as String? ?? '',
      line: json['line'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      address: json['address'] as String? ?? '',
      tambonCode: json['tambonCode'] as String? ?? '',
      tambon: json['tambon'] as String? ?? '',
      amphoeCode: json['amphoeCode'] as String? ?? '',
      amphoe: json['amphoe'] as String? ?? '',
      provinceCode: json['provinceCode'] as String? ?? '',
      province: json['province'] as String? ?? '',
      postnoCode: json['postnoCode'] as String? ?? '',
      postno: json['postno'] as String? ?? '',
      job: json['job'] as String? ?? '',
      idcard: json['idcard'] as String? ?? '',
      countUnit: json['countUnit'] as String? ?? '',
      lv0: json['lv0'] as String? ?? '',
      lv1: json['lv1'] as String? ?? '',
      lv2: json['lv2'] as String? ?? '',
      lv3: json['lv3'] as String? ?? '',
      lv4: json['lv4'] as String? ?? '',
      lv5: json['lv5'] as String? ?? '',
      linkAccount: json['linkAccount'] as String? ?? '',
      officerCode: json['officerCode'] as String? ?? '',
    );
  }

  User({
    this.prefixName = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.category = '',
    this.code = '',
    this.username = '',
    this.password = '',
    this.isActive = false,
    this.status = '',
    this.createBy = '',
    this.createDate = '',
    this.imageUrl = '',
    this.updateBy = '',
    this.updateDate = '',
    this.birthDay = '',
    this.phone = '',
    this.facebookID = '',
    this.googleID = '',
    this.lineID = '',
    this.appleID = '',
    this.line = '',
    this.sex = '',
    this.address = '',
    this.tambonCode = '',
    this.tambon = '',
    this.amphoeCode = '',
    this.amphoe = '',
    this.provinceCode = '',
    this.province = '',
    this.postnoCode = '',
    this.postno = '',
    this.job = '',
    this.idcard = '',
    this.countUnit = '',
    this.lv0 = '',
    this.lv1 = '',
    this.lv2 = '',
    this.lv3 = '',
    this.lv4 = '',
    this.lv5 = '',
    this.linkAccount = '',
    this.officerCode = '',
  });

  Map<String, dynamic> toJson() => {
        'prefixName': prefixName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'category': category,
        'code': code,
        'username': username,
        'password': password,
        'isActive': isActive,
        'status': status,
        'createBy': createBy,
        'createDate': createDate,
        'imageUrl': imageUrl,
        'updateBy': updateBy,
        'updateDate': updateDate,
        'birthDay': birthDay,
        'phone': phone,
        'facebookID': facebookID,
        'googleID': googleID,
        'lineID': lineID,
        'appleID': appleID,
        'line': line,
        'sex': sex,
        'address': address,
        'tambonCode': tambonCode,
        'tambon': tambon,
        'amphoeCode': amphoeCode,
        'amphoe': amphoe,
        'provinceCode': provinceCode,
        'province': province,
        'postnoCode': postnoCode,
        'postno': postno,
        'job': job,
        'idcard': idcard,
        'countUnit': countUnit,
        'lv0': lv0,
        'lv1': lv1,
        'lv2': lv2,
        'lv3': lv3,
        'lv4': lv4,
        'lv5': lv5,
        'linkAccount': linkAccount,
        'officerCode': officerCode,
      };

  void save() {
    // ignore: avoid_print
    print('saving user using a web service');
  }
}

class DataUser {
  String facebookID;
  String appleID;
  String googleID;
  String lineID;
  String email;
  String imageUrl;
  String category;
  String username;
  String password;
  String prefixName;
  String firstName;
  String lastName;

  DataUser({
    this.facebookID = '',
    this.appleID = '',
    this.googleID = '',
    this.lineID = '',
    this.email = '',
    this.imageUrl = '',
    this.category = '',
    this.username = '',
    this.password = '',
    this.prefixName = '',
    this.firstName = '',
    this.lastName = '',
  });
}

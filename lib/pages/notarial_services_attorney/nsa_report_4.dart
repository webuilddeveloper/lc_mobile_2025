// ignore_for_file: must_be_immutable, await_only_futures

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widget/header_v2.dart';
import '../../widget/text_field.dart';
import 'nsa_report_pay.dart';

class NsaReport4Page extends StatefulWidget {
  NsaReport4Page({super.key, required this.profileCode, this.model});

  String profileCode;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _NsaReport4PageState createState() => _NsaReport4PageState();
}

class _NsaReport4PageState extends State<NsaReport4Page> {
  final storage = const FlutterSecureStorage();
  int page = 1;
  late XFile _image;

  TextEditingController text = TextEditingController();
  List<dynamic> prefixNameList = [
    {'code': '0', 'title': 'นาย'},
    {'code': '1', 'title': 'นาง'},
    {'code': '2', 'title': 'นางสาว'},
  ];

  List<dynamic> evidenceList = [
    {
      'code': '1',
      'title': 'ใบสำคัญการขึ้นทะเบียน',
      'isSelected': false,
      'file': null
    },
    {
      'code': '2',
      'title': 'สำเนาทะเบียนบ้าน',
      'isSelected': false,
      'file': null
    },
    {
      'code': '3',
      'title': 'รูปถ่ายสวมครุยเนติบัณฑิต ขนาด 2 นิ้ว จำนวน 2 รูป',
      'isSelected': false,
      'file': null
    },
    {
      'code': '4',
      'title': 'สำเนาใบเปลี่ยนชื่อ/ชื่อสกุล',
      'isSelected': false,
      'file': null
    },
    {
      'code': '5',
      'title': 'ใบแจ้งความจากเจ้าพนักงาน',
      'isSelected': false,
      'file': null
    },
    {'code': '6', 'title': 'อื่นๆ', 'isSelected': false, 'file': null},
  ];
  List<dynamic> provinceList = [];
  List<dynamic> districtList = [];
  List<dynamic> subDistrictList = [];

  List<dynamic> provinceOfficeList = [];
  List<dynamic> districtOfficeList = [];
  List<dynamic> subDistrictOfficeList = [];
  dynamic _modelReport = {};
  dynamic model = {
    'prefix': '',
    'lawyerLicenseNo': '',
    'isChangeName': false,
    'isChangeCurAddress': false,
    'isChangeOfficeAddress': false,
    'isOtherLicenseFile': false,
    'isRegistrationCertificateFile': true,
    'isHouseRegisCopyFile': false,
    'isPhotoGraduationFile': true,
    'isNameChangeCerFile': false,
    'isPoliceReportFile': false,
    'isOtherFile': false,
    'licenseRequestFile': '',
    "paymentAmount": '',
    "paymentDate": '',
    "paymentTime": '',
    "paymentImageUrl": '',
    "paymentType": '',
  };
  int selectedPrefix = 1;
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();
  late FilePickerResult docFile1;
  late FilePickerResult docFile2;
  late FilePickerResult docFile3;
  late FilePickerResult docFile4;
  late FilePickerResult docFile5;
  late FilePickerResult pickedFile;
  final _formKeyPage1 = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    if ((widget.profileCode) != '') {
      callRead();
    }
    model['profileCode'] = widget.profileCode;

    getProvince();
    var now = DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  callRead() async {
    await postObjectData("reporter/tr04/read", {
      'profileCode': widget.profileCode,
    }).then((value) async => {
          if (value['status'] == 'S')
            {
              if (value['objectData'].length > 0)
                {
                  setState(() {
                    model = value['objectData'][0];
                  }),
                  getDistrict(type: '1', provinceCode: model['provinceCode']),
                  getSubDistrict(
                      type: '1',
                      provinceCode: model['provinceCode'],
                      districtCode: model['districtCode']),
                  getDistrict(
                      type: '2', provinceCode: model['provinceCodeOffice']),
                  getSubDistrict(
                      type: '2',
                      provinceCode: model['provinceCodeOffice'],
                      districtCode: model['districtCodeOffice']),
                }
              else
                {
                  _createNewData(),
                }
            },
          Future.delayed(const Duration(seconds: 1)).then((value) => {
                _formKeyPage1.currentState?.reset(),
              })
        });
  }

  void _createNewData() {
    setState(() {
      model['prefixName'] = widget.model['title_t'] ?? '';
      model['firstName'] = widget.model['fname_t'] ?? '';
      model['lastName'] = widget.model['lname_t'] ?? '';
      model['lawyerLicenseNo'] = widget.model['com_no'] ?? '';
      model['lawyerOfficerNo'] = widget.model['code_id'] ?? '';

      model['address'] = widget.model['haddr_t'] ?? '';
      model['phone'] = widget.model['hphone'] ?? '';
      model['fax'] = widget.model['hfax'] ?? '';
    });
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        districtList.clear();
        subDistrictList.clear();
        districtOfficeList.clear();
        subDistrictOfficeList.clear();
        provinceList = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict(
      {String type = "", required String provinceCode}) async {
    final result = await postObjectData("route/district/read", {
      'province': model['provinceCode'],
    });
    if (result['status'] == 'S') {
      setState(() {
        if (type == '1') {
          subDistrictList.clear();
          districtList = result['objectData'];
        } else if (type == '2') {
          subDistrictOfficeList.clear();
          districtOfficeList = result['objectData'];
        }
      });
    }
  }

  Future<dynamic> getSubDistrict(
      {String type = "",
      required String provinceCode,
      required String districtCode}) async {
    final result = await postObjectData("route/tambon/read", {
      'province': model['provinceCode'],
      'district': model['districtCode'],
    });
    if (result['status'] == 'S') {
      setState(() {
        if (type == '1') {
          subDistrictList = result['objectData'];
        } else if (type == '2') {
          subDistrictOfficeList = result['objectData'];
        }
      });
    }
  }

  _save() async {
    String url =
        ((model['profileCode'] ?? '') != '' && (model['code'] ?? '') != '')
            ? 'reporter/tr04/update'
            : 'reporter/tr04/create';
    print('>>>>url>>>> ${model}');
    _modelReport =
        await postDio(reporter04ReadApi, {'code': model['profileCode']});
    if (_modelReport.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NsaReportPayForm(
            type: 'report04',
            title: '',
          ),
        ),
      );
    } else {
      await postObjectData(url, model).then((value) => {
            print('>>>>>>>> ${value}'),
            if (value['status'] == 'S')
              {
                // dialogSuccess(context,
                //     title: 'บันทึกสำเร็จ',
                //     subTitle: '',
                //     autoClose: true, actionAfterAutoClose: () {
                //   Navigator.pop(context, false);
                // }),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NsaReportPayForm(
                      type: 'report04',
                      title: '',
                    ),
                  ),
                ),
              }
            // print('>>>>>>>> ${value}')
            // dialogSuccess(context, title: 'บันทึกสำเร็จ', subTitle: '');
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: page == 0 ? Colors.white : const Color(0xFFFF7F7F7),
        appBar: headerNSA(context, callback: () {
          // page == 1
          //     ? goBack()
          //     : setState(
          //         () {
          //           page -= 1;
          //         },
          //       );
          goBack();
        },
            // contentRight: Text('$page/2'),
            contentRight: Container(),
            title: 'แบบ ทรอ.4',
            backgroundColor: page == 0 ? Colors.white : const Color(0xFFFF7F7F7)),
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKeyPage1,
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
              padding: const EdgeInsets.all(16),
              // children: [page == 1 ? _buildPage1() : _buildPage2()],
              children: [_buildPage1()],
            ),
          ),
        ),
      ),
    );
  }

  _buildPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'คําขอเปลี่ยนแปลงข้อมูล',
            style: TextStyle(color: Color(0xFF707070), fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: textFieldReport(
                label: 'เขียนที่',
                model: model['writeAt'] ?? '',
                onChanged: (value) {
                  setState(() {
                    model['writeAt'] = value;
                  });
                },
                validator: (value) {},
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => dialogOpenPickerDate(
                  callBack: (p0) {
                    setState(() {
                      model['writeDate'] = p0;
                    });
                  },
                ),
                child: AbsorbPointer(
                  child: textFieldReport(
                      label: 'วัน-เดือน-ปี',
                      model: model['writeDate'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          model['writeDate'] = value;
                        });
                      },
                      validator: (value) {},
                      isGlobalKey: true),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            '1. ข้าพเจ้า',
            style: TextStyle(color: Colors.black, fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: dropdownFieldReport(
                label: 'คำนำหน้า',
                hintText: 'เลือกคำนำหน้า',
                listItem: prefixNameList,
                value: model['prefixName'] != '' ? model['prefixName'] : null,
                onChanged: (e) => {
                  setState(() {model['prefixName'] = e;})
                },
                validator: (value) {
                  // if (value?.isEmpty ?? true) {
                  //   return 'กรุณาเลือกคำนำหน้า';
                  // }
                },
                onTap: () {},
              ),
            ),
            const Expanded(flex: 1, child: SizedBox())
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: textFieldReport(
                label: 'ชื่อ (ภาษาไทย)',
                model: model['firstName'],
                key: _formKeyPage1,
                onChanged: (value) {
                  setState(() {
                    model['firstName'] = value;
                  });
                },
                // isGlobalKey: true,
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'กรุณากรอก';
                  // }
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: textFieldReport(
                label: 'นามสกุล (ภาษาไทย)',
                model: model['lastName'] ?? '',
                onChanged: (value) {
                  setState(() {
                    model['lastName'] = value;
                  });
                },
                validator: (value) {
                  // if (value.isEmpty) {
                  //   return 'กรุณากรอก';
                  // }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        textFieldReport(
          label: 'เลขที่ใบอนุญาตให้เป็นทนายความ',
          model: model['lawyerLicenseNo'] ?? '',
          onChanged: (value) {
            setState(() {
              model['lawyerLicenseNo'] = value;
            });
          },
          validator: (value) {
            // if (value.isEmpty) {
            //   return 'กรุณากรอก';
            // }
          },
          // enabled: false,
        ),
        const SizedBox(
          height: 15,
        ),
        textFieldReport(
          label: 'ทะเบียนทนายความผู้ทำคำรับรองลายมือชื่อและเอกสารเลขที่',
          model: model['lawyerOfficerNo'] ?? '',
          onChanged: (value) {
            setState(() {
              model['lawyerOfficerNo'] = value;
            });
          },
          validator: (value) {
            // if (value.isEmpty) {
            //   return 'กรุณากรอก';
            // }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'มีความประสงค์ขอ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.start,
        ),
        CheckBox(
          title: 'เปลี่ยนชื่อ/ชื่อสกุลจากเดิมเป็น',
          value: model['isChangeName'] ?? false,
          onChange: (param) {
            setState(
              () {
                model['isChangeName'] = !model['isChangeName'];
                model['isNameChangeCerFile'] = !model['isNameChangeCerFile'];
              },
            );
          },
        ),
        model['isChangeName']
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'ชื่อ',
                          model: model['firstNameNew'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['firstNameNew'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'นามสกุล',
                          model: model['lastNameNew'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['lastNameNew'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'FirstName',
                          model: model['firstNameEnNew'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['firstNameEnNew'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'LastName',
                          model: model['lastNameEnNew'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['lastNameEnNew'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),
        CheckBox(
          title: 'เปลี่ยนที่อยู่ตามทะเบียนบ้านเป็น',
          value: model['isChangeCurAddress'] ?? false,
          onChange: (param) {
            setState(
              () {
                model['isChangeCurAddress'] = !model['isChangeCurAddress'];
                model['isHouseRegisCopyFile'] = !model['isHouseRegisCopyFile'];
              },
            );
          },
        ),
        model['isChangeCurAddress']
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'เลขที่',
                          model: model['address'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['address'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'หมู่ที่',
                          model: model['moo'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['moo'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'ตรอก/ซอย',
                          model: model['soi'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['soi'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'ถนน',
                          model: model['street'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['street'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'จังหวัด',
                          hintText: 'เลือกจังหวัด',
                          listItem: provinceList,
                          value: model['provinceCode'] != ''
                              ? model['provinceCode']
                              : null,
                          onChanged: (e) async {
                            setState(
                              () {
                                dynamic provinceModel = provinceList
                                    .firstWhere((x) => x['code'] == e);
                                model['provinceCode'] = e;
                                model['provinceTitle'] = provinceModel['title'];
                                model['districtCode'] = null;
                                model['subDistrictCode'] = null;
                                model['postCode'] = '';
                              },
                            );
                            getDistrict(type: '1', provinceCode: '');
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกจังหวัด';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'อำเภอ/เขต',
                          hintText: 'เลือกอำเภอ/เขต',
                          listItem: districtList,
                          value: model['districtCode'] != ''
                              ? model['districtCode']
                              : null,
                          onChanged: (e) async => {
                            setState(
                              () {
                                dynamic districtModel = districtList
                                    .firstWhere((x) => x['code'] == e);
                                model['districtCode'] = e;
                                model['districtTitle'] = districtModel['title'];
                                model['subDistrictCode'] = null;
                                model['postCode'] = '';
                              },
                            ),
                            getSubDistrict(
                                type: '1', provinceCode: '', districtCode: ''),
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกอำเภอ/เขต';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'ตำบล/แขวง',
                          hintText: 'เลือกตำบล/แขวง',
                          listItem: subDistrictList,
                          value: model['subDistrictCode'] != ''
                              ? model['subDistrictCode']
                              : null,
                          onChanged: (e) => {
                            setState(
                              () {
                                dynamic subDistrictModel = subDistrictList
                                    .firstWhere((x) => x['code'] == e);
                                model['subDistrictCode'] = e;
                                model['subDistrictTitle'] =
                                    subDistrictModel['title'];
                                model['postCode'] =
                                    subDistrictModel['postCode'].toString();
                              },
                            ),
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกตำบล/แขวง';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'รหัสไปรษณีย์',
                          isGlobalKey: true,
                          model: model['postCode'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['postCode'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textFieldReport(
                    label: 'เบอร์โทรศัพท์',
                    model: model['phone'] ?? '',
                    onChanged: (value) {
                      setState(() {
                        model['phone'] = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกเบอร์โทรศัพท์';
                      } else if (value.length < 10) {
                        return 'กรุณากรอกหมายเลขโทรศัพท์ให้ครบ 10 หลัก';
                      }
                    },
                  ),
                ],
              )
            : Container(),
        CheckBox(
          title: 'เปลี่ยนแปลงที่อยู่สำนักงาน/บริษัทเป็น',
          value: model['isChangeOfficeAddress'] ?? false,
          onChange: (param) {
            setState(
              () {
                model['isChangeOfficeAddress'] =
                    !model['isChangeOfficeAddress'];
              },
            );
          },
        ),
        model['isChangeOfficeAddress']
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'เลขที่',
                          model: model['addressOffice'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['addressOffice'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'หมู่ที่',
                          model: model['mooOffice'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['mooOffice'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textFieldReport(
                          label: 'ตรอก/ซอย',
                          model: model['soiOffice'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['soiOffice'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'ถนน',
                          model: model['streetOffice'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['streetOffice'] = value;
                            });
                          },
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'จังหวัด',
                          hintText: 'เลือกจังหวัด',
                          listItem: provinceList,
                          value: model['provinceCodeOffice'] != ''
                              ? model['provinceCodeOffice']
                              : null,
                          onChanged: (e) async {
                            setState(
                              () {
                                dynamic provinceModel = provinceList
                                    .firstWhere((x) => x['code'] == e);
                                model['provinceCodeOffice'] = e;
                                model['provinceTitleOffice'] =
                                    provinceModel['title'];
                                model['districtCodeOffice'] = null;
                                model['subDistrictCodeOffice'] = null;
                                model['postCodeOffice'] = '';
                              },
                            );
                            getDistrict(type: '2', provinceCode: '');
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกจังหวัด';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'อำเภอ/เขต',
                          hintText: 'เลือกอำเภอ/เขต',
                          listItem: districtList,
                          value: model['districtCodeOffice'] != ''
                              ? model['districtCodeOffice']
                              : null,
                          onChanged: (e) async => {
                            setState(
                              () {
                                dynamic districtModel = districtList
                                    .firstWhere((x) => x['code'] == e);
                                model['districtCodeOffice'] = e;
                                model['districtTitleOffice'] =
                                    districtModel['title'];
                                model['subDistrictCodeOffice'] = null;
                                model['postCodeOffice'] = '';
                              },
                            ),
                            getSubDistrict(
                                type: '2', provinceCode: '', districtCode: ''),
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกอำเภอ/เขต';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: dropdownFieldReport(
                          label: 'ตำบล/แขวง',
                          hintText: 'เลือกตำบล/แขวง',
                          listItem: subDistrictList,
                          value: model['subDistrictCodeOffice'] != ''
                              ? model['subDistrictCodeOffice']
                              : null,
                          onChanged: (e) => {
                            setState(
                              () {
                                dynamic subDistrictModel = subDistrictList
                                    .firstWhere((x) => x['code'] == e);
                                model['subDistrictCodeOffice'] = e;
                                model['subDistrictTitleOffice'] =
                                    subDistrictModel['title'];
                                model['postCodeOffice'] =
                                    subDistrictModel['postCode'].toString();
                              },
                            ),
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาเลือกตำบล/แขวง';
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: textFieldReport(
                          label: 'รหัสไปรษณีย์',
                          isGlobalKey: true,
                          model: model['postCodeOffice'] ?? '',
                          onChanged: (value) {
                            setState(() {
                              model['postCodeOffice'] = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณากรอก';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textFieldReport(
                    label: 'เบอร์โทรศัพท์',
                    model: model['phoneOffice'] ?? '',
                    onChanged: (value) {
                      setState(() {
                        model['phoneOffice'] = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกเบอร์โทรศัพท์';
                      } else if (value.length < 10) {
                        return 'กรุณากรอกหมายเลขโทรศัพท์ให้ครบ 10 หลัก';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textFieldReport(
                    label: 'E-mail',
                    model: model['emailOffice'] ?? '',
                    onChanged: (value) {
                      setState(() {
                        model['emailOffice'] = value;
                      });
                    },
                    validator: (value) {},
                  ),
                ],
              )
            : Container(),
        CheckBoxAttachFile(
          title: 'อื่นๆ',
          value: true,
          file: model['otherLicenseFile'] ?? '',
          isSelected: true,
          onChange: (param) {
            setState(() {
              model['isOtherLicenseFile'] = !model['isOtherLicenseFile'];
              if (param == false) {
                model['otherLicenseFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['otherLicenseFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['otherLicenseFile'] = '';
              },
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'พร้อมกันนี้ ข้าพเจ้าได้แนบหลักฐานต่างๆมาด้วย คือ',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        CheckBoxAttachFile(
          title: 'ใบสำคัญการขึ้นทะเบียน',
          value: model['isRegistrationCertificateFile'],
          file: model['registrationCertificateFile'] ?? '',
          isSelected: model['isRegistrationCertificateFile'],
          onChange: (param) {
            setState(() {
              if (param == false) {
                model['registrationCertificateFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['registrationCertificateFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['registrationCertificateFile'] = '';
              },
            );
          },
        ),
        CheckBoxAttachFile(
          title: 'สำเนาทะเบียนบ้าน',
          value: model['isHouseRegisCopyFile'],
          file: model['houseRegisCopyFile'] ?? '',
          isSelected: model['isChangeCurAddress'],
          onChange: (param) {
            setState(() {
              model['isHouseRegisCopyFile'] = !model['isHouseRegisCopyFile'];
              if (param == false) {
                model['houseRegisCopyFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['houseRegisCopyFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['houseRegisCopyFile'] = '';
              },
            );
          },
        ),
        CheckBoxAttachFile(
          title: 'รูปถ่ายสวมชุดครุยเนติบัณฑิต ขนาด2นิ้ว',
          value: model['isPhotoGraduationFile'],
          file: model['photoGraduationFile'] ?? '',
          isImage: true,
          isSelected: model['isPhotoGraduationFile'],
          onChange: (param) {
            setState(() {
              // model['isOtherLicenseFile'] =
              //     !model['isOtherLicenseFile'];
              if (param == false) {
                model['photoGraduationFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['photoGraduationFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['photoGraduationFile'] = '';
              },
            );
          },
        ),
        CheckBoxAttachFile(
          title: 'สำเนาใบเปลี่ยนชื่อ/ชื่อสกุล',
          value: model['isNameChangeCerFile'],
          file: model['nameChangeCerFile'] ?? '',
          isSelected: model['isChangeName'],
          onChange: (param) {
            setState(() {
              model['isNameChangeCerFile'] = !model['isNameChangeCerFile'];
              if (param == false) {
                model['nameChangeCerFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['nameChangeCerFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['nameChangeCerFile'] = '';
              },
            );
          },
        ),
        CheckBoxAttachFile(
          title: 'ใบแจ้งความจากเจ้าพนักงาน',
          value: model['isPoliceReportFile'],
          file: model['policeReportFile'] ?? '',
          // isSelected: model['isPoliceReportFile'],
          onChange: (param) {
            print('>>>>>>>>');
            setState(() {
              model['isPoliceReportFile'] = !model['isPoliceReportFile'];
              if (param == false) {
                model['policeReportFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['policeReportFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['policeReportFile'] = '';
              },
            );
          },
        ),
        CheckBoxAttachFile(
          title: 'อื่นๆ',
          value: model['isOtherFile'],
          file: model['otherFile'] ?? '',
          // isSelected: model['isOtherFile'],
          onChange: (param) {
            setState(() {
              model['isOtherFile'] = !model['isOtherFile'];
              if (param == false) {
                model['otherFile'] = '';
              }
            });
          },
          onSelectFile: (param) {
            setState(() {
              model['otherFile'] = param;
            });
          },
          onRemoveFile: (param) {
            setState(
              () {
                model['otherFile'] = '';
              },
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'แนบไฟล์ลายมือชื่อผู้ยื่นคำขอ',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        AttachFile(
            value: true,
            file: model['licenseRequestFile'],
            onChange: (param) {
              setState(() {
                // model['isCopyLawyersMemberFile'] =
                //     !model['isCopyLawyersMemberFile'];
                if (param == false) {
                  model['licenseRequestFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['licenseRequestFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['licenseRequestFile'] = '';
              });
            }),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFED6B2D)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  // side: BorderSide(color: Colors.red)
                ))),
            onPressed: () {
              bool validate = _formKeyPage1.currentState!.validate();
              print('======== $validate');
              if (validate) {
                if ((model['isOtherLicenseFile'] ?? true) &&
                    (model['otherLicenseFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isRegistrationCertificateFile'] ?? true) &&
                    (model['registrationCertificateFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isHouseRegisCopyFile'] ?? true) &&
                    (model['houseRegisCopyFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isPhotoGraduationFile'] ?? true) &&
                    (model['photoGraduationFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isNameChangeCerFile'] ?? true) &&
                    (model['nameChangeCerFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isPoliceReportFile'] ?? true) &&
                    (model['policeReportFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else {
                  _save();
                  // setState(() => {page = 2});
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              child: const Text(
                'ถัดไป',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  // decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  dialogOpenPickerDate({required Null Function(dynamic p0) callBack}) {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: const dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd-MM-yyyy").format(date),
            );
          },
        );
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dt_picker.LocaleType.th,
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  Widget AttachFile({
    required Function(bool) onChange,
    required Function(String) onSelectFile,
    required Function(String) onRemoveFile,
    bool value = false,
    required String file,
    bool isValidate = false,
    bool isImage = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: GestureDetector(
            onTap: () async {
              setState(
                () {
                  isLoading = true;
                  _showPickerImage(context, onSelectFile);
                  // uploadFile().asStream;
                  // uploadFile().asStream().listen(
                  //       (v) async => {
                  //         await onSelectFile(v),
                  //       },
                  //       onDone: () => {},
                  //       onError: (e) =>
                  //           print(' stream.onError(): ${e.toString()}'),
                  //       // cancelOnError: false, // default - onDone() will be called even when errors happens
                  //       // cancelOnError: true, // onDone() will NOT be called when errors happens
                  //     );
                },
              );
            },
            child: Row(
              children: [
                (file) != ''
                    ? Expanded(
                        child: isImage
                            ? Container(
                                alignment: Alignment.centerLeft,
                                height: 150,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      file,
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          onRemoveFile('234');
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(12),
                                // alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color.fromARGB(117, 128, 153, 47),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        file.split('/').last.toString(),
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Kanit',
                                            overflow: TextOverflow.ellipsis),
                                        // maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        onRemoveFile('234');
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            // alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color.fromARGB(117, 128, 153, 47),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.attach_file,
                                  size: 20,
                                ),
                                Text(
                                  isImage ? 'แนบรูปภาพ' : 'แนบไฟล์',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ((file) == '' && isValidate)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    isImage ? 'กรุณาแนบรูปภาพ' : 'กรุณาแนบไฟล์',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                        color: Colors.red),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget CheckBoxAttachFile({
    String title = "",
    required Function(bool) onChange,
    required Function(String) onSelectFile,
    required Function(String) onRemoveFile,
    bool value = false,
    required String file,
    bool isSelected = false,
    bool isImage = false,
  }) {
    return Column(
      children: [
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
          activeColor: const Color(0xFF758C29),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
          selected: (value),
          value: isSelected ? true : (value),
          onChanged: (p0) => isSelected ? null : onChange(p0!),
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
        (value)
            ? Padding(
                padding: const EdgeInsets.only(left: 55),
                child: GestureDetector(
                  onTap: () async {
                    setState(
                      () {
                        isLoading = true;
                        _showPickerImage(context, onSelectFile);
                        // uploadFile().asStream;
                        // uploadFile().asStream().listen(
                        //       (v) async => {
                        //         await onSelectFile(v),
                        //       },
                        //       onDone: () => {},
                        //       onError: (e) =>
                        //           print(' stream.onError(): ${e.toString()}'),
                        //       // cancelOnError: false, // default - onDone() will be called even when errors happens
                        //       // cancelOnError: true, // onDone() will NOT be called when errors happens
                        //     );
                        // uploadFile().then(
                        //   (value) async => {
                        //     await onSelectFile(value),
                        //     isLoading = false,
                        //   },
                        // );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      (file) != ''
                          ? Expanded(
                              child: isImage
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      height: 150,
                                      child: Stack(
                                        children: [
                                          file.toLowerCase().endsWith('.pdf')
                                              ? Image.asset(
                                                  'assets/images/file-other.png',
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.network(
                                                  file,
                                                  fit: BoxFit.contain,
                                                ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                onRemoveFile('234');
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(12),
                                      // alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color:
                                            const Color.fromARGB(117, 128, 153, 47),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              file.split('/').last.toString(),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'Kanit',
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              // maxLines: 1,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              onRemoveFile('234');
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  // alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color.fromARGB(117, 128, 153, 47),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_file,
                                        size: 20,
                                      ),
                                      Text(
                                        isImage ? 'แนบรูปภาพ' : 'แนบไฟล์',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Kanit',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (file) == ''
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          isImage
                                              ? 'กรุณาแนบรูปภาพ'
                                              : 'กรุณาแนบไฟล์',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Kanit',
                                              color: Colors.red),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget CheckBox({
    String title = "",
    required Function(bool) onChange,
    bool value = false,
    bool isSelected = false,
  }) {
    return Column(
      children: [
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
          activeColor: const Color(0xFF758C29),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
          selected: (value),
          value: isSelected ? true : (value),
          onChanged: (p0) => isSelected ? null : onChange(p0!),
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
      ],
    );
  }

  void _showPickerImage(context, Function(String) onSelectFile) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text(
                    'ไฟล์ในเครื่อง',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imageFromFile('file', onSelectFile);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text(
                    'อัลบั้มรูปภาพ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromGallery('image', onSelectFile);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                    'กล้องถ่ายรูป',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera('image', onSelectFile);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> requestPermissions() async {
    // สำหรับ Android 13+
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }

    if (await Permission.videos.isDenied) {
      await Permission.videos.request();
    }

    // สำหรับการจัดการไฟล์ทั่วไป
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  _imageFromFile(String type, Function(String) onSelectFile) async {
    requestPermissions();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = XFile(result.files.single.path!);
      });
    }
    _upload(type, onSelectFile);
  }

  _imgFromCamera(String type, Function(String) onSelectFile) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload(type, onSelectFile);
  }

  _imgFromGallery(String type, Function(String) onSelectFile) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });

    _upload(type, onSelectFile);
  }

  void _upload(String type, Function(String) onSelectFile) async {
    if (_image == null) return;

    uploadImageX(_image).then((res) {
      onSelectFile(res);
    }).catchError((err) {
      print(err);
    });
  }

  // ignore: missing_return
  Future<String> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    try {
      if (result != null) {
        String? filePath = result.files.single.path;

        if (filePath != null) {
          XFile file = XFile(filePath);

          return uploadImageX(file);
        }
      }

      return 'No file selected';
    } catch (e) {
      return 'Error: $e';
    }
  }
}

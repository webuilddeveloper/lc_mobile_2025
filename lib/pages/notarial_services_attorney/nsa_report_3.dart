// ignore_for_file: must_be_immutable

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

class NsaReport3Page extends StatefulWidget {
  NsaReport3Page({
    super.key,
    required this.profileCode,
    this.model,
  });

  String profileCode;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _NsaReport3PageState createState() => _NsaReport3PageState();
}

class _NsaReport3PageState extends State<NsaReport3Page> {
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
      'title': 'ใบสำคัญฉบับเดิม (ถ้ามี)',
      'isSelected': false,
      'file': null
    },
    {
      'code': '2',
      'title': 'ตราประทับเดิม (ถ้ามี)',
      'isSelected': false,
      'file': null
    },
    {
      'code': '3',
      'title': 'หนังสือมอบอำนาจให้ยื่นคำขอแทน',
      'isSelected': false,
      'file': null
    },
    {
      'code': '4',
      'title': 'รูปถ่ายสีสวมครุยเนติบัณฑิต ขนาด 2 นิ้ว จำนวน 2 รูป',
      'isSelected': false,
      'file': null
    },
    {
      'code': '5',
      'title': 'ลักฐานการแจ้งความในใบสำคัญและหรือตราประทับสูญหาย',
      'isSelected': false,
      'file': null
    },
  ];
  List<dynamic> provinceList = [];
  List<dynamic> districtList = [];
  List<dynamic> subDistrictList = [];
  dynamic model = {
    'prefix': '',
    'lawyerLicenseNo': '',
    'isOriginalCerFile': false,
    'isOriginalSealFile': false,
    'isProxyFile': false,
    'isPhotoGraduationFile': true,
    'isEvidenceNotificationFile': false,
    'isCopyLawyersMemberFile': true,
    'isReplacementRegister': false,
    'isIssuanceStamp': false,
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
  bool isLoading = false;
  final _formKeyPage1 = GlobalKey<FormState>();
  dynamic _modelReport = {};

  @override
  void initState() {
    if ((widget.profileCode) != '') {
      callRead();
    }
    model['profileCode'] = widget.profileCode;
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
    await postObjectData("reporter/tr03/read", {
      'profileCode': widget.profileCode,
    }).then((value) => {
          if (value['status'] == 'S')
            {
              if (value['objectData'].length > 0)
                {
                  setState(() {
                    model = value['objectData'][0];
                  }),
                  getProvince(),
                  getDistrict(),
                  getSubDistrict(),
                }
              else
                {
                  _createNewData(),
                }
            }
        });

    Future.delayed(const Duration(seconds: 1)).then((value) => {
          _formKeyPage1.currentState!.reset(),
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
      getProvince();
      getDistrict();
      getSubDistrict();
    });
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        districtList.clear();
        subDistrictList.clear();
        provinceList = result['objectData'];
        print('>>>>>>>> ${provinceList}');
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': model['provinceCode'],
    });
    if (result['status'] == 'S') {
      setState(() {
        subDistrictList.clear();
        districtList = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': model['provinceCode'],
      'district': model['districtCode'],
    });
    if (result['status'] == 'S') {
      setState(() {
        subDistrictList = result['objectData'];
        print('>>>>>>>>>>>>> ${result['objectData']}');
      });
    }
  }

  _save() async {
    String url = model['code'] != '' && model['code'] != null
        ? 'reporter/tr03/update'
        : 'reporter/tr03/create';
    var typePrice =
        model['isReplacementRegister'] == true ? 'report03_21' : 'report03_22';

    _modelReport =
        await postDio(reporter03ReadApi, {'code': model['profileCode']});
    if (_modelReport.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NsaReportPayForm(
            type: typePrice,
            title: '',
          ),
        ),
      );
    } else {
      await postObjectData(url, model).then((value) => {
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
                    builder: (context) => NsaReportPayForm(
                      type: typePrice,
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
        backgroundColor: page == 0 ? Colors.white : const Color(0xffff7f7f7),
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
            // contentRight: Text('${model['replacementRegisterPrice']}/2'),
            contentRight: Container(),
            title: 'แบบ ทรอ.3',
            backgroundColor:
                page == 0 ? Colors.white : const Color(0xffff7f7f7)),
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
            'คำขอรับใบแทนใบสำคัญการขึ้นทะเบียน/ตราประทับ\nทนายความผู้ทำคำรับรองลายมือชื่อและเอกสาร',
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
                  setState(() {
                    model['prefixName'] = e;
                  })
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาเลือกคำนำหน้า';
                  }
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
                label: 'นามสกุล (ภาษาไทย)',
                model: model['lastName'] ?? '',
                onChanged: (value) {
                  setState(() {
                    model['lastName'] = value;
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
          label: 'เลขที่ใบอนุญาตให้เป็นทนายความ',
          model: model['lawyerLicenseNo'] ?? '',
          onChanged: (value) {
            setState(() {
              model['lawyerLicenseNo'] = value;
            });
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณากรอก';
            }
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
            if (value.isEmpty) {
              return 'กรุณากรอก';
            }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: textFieldReport(
                label: 'ที่อยู่ปัจจุบัน เลขที่',
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
                value:
                    model['provinceCode'] != '' ? model['provinceCode'] : null,
                onChanged: (e) async {
                  setState(
                    () {
                      dynamic provinceModel =
                          provinceList.firstWhere((x) => x['code'] == e);
                      model['provinceCode'] = e;
                      model['provinceTitle'] = provinceModel['title'];
                      model['districtCode'] = null;
                      model['subDistrictCode'] = null;
                      model['postCode'] = '';
                    },
                  );
                  getDistrict();
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
                value:
                    model['districtCode'] != '' ? model['districtCode'] : null,
                onChanged: (e) async => {
                  setState(
                    () {
                      dynamic districtModel =
                          districtList.firstWhere((x) => x['code'] == e);
                      model['districtCode'] = e;
                      model['districtTitle'] = districtModel['title'];
                      model['subDistrictCode'] = null;
                      model['postCode'] = '';
                    },
                  ),
                  getSubDistrict(),
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
                      dynamic subDistrictModel =
                          subDistrictList.firstWhere((x) => x['code'] == e);
                      model['subDistrictCode'] = e;
                      model['subDistrictTitle'] = subDistrictModel['title'];
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
        const SizedBox(
          height: 15,
        ),
        textFieldReport(
          label: 'โทรสาร',
          model: model['fax'] ?? '',
          onChanged: (value) {
            setState(() {
              model['fax'] = value;
            });
          },
          validator: (value) {},
        ),
        const SizedBox(
          height: 15,
        ),
        textFieldReport(
          label: 'E-mail',
          model: model['email'] ?? '',
          onChanged: (value) {
            setState(() {
              model['email'] = value;
            });
          },
          validator: (value) {},
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          '2. ข้าพเจ้ามีความประสงค์ดังนี้',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const Text(
          '2.1 ขอรับใบแทนสำคัญการขึ้นทะเบียนให้เป็นทนายความผู้ทำคำรับรองลายมือชื่อและเอกสารเนื่องจากใบสำคัญเดิม',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        (model['requestReplacementDoc'] ?? '') == ''
            ? const Text(
                'กรุณาเลือกตัวเลือก',
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.start,
              )
            : Container(),
        RadioListTile(
          contentPadding: const EdgeInsets.all(0),
          value: '1',
          groupValue: model['requestReplacementDoc'],
          title: const Text(
            "สูญหาย",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 15.00,
                overflow: TextOverflow.ellipsis),
          ),
          activeColor: const Color(0xFF758C29),
          onChanged: (value) => setState(
            (() {
              model['requestReplacementDoc'] = '1';
              model['isEvidenceNotificationFile'] = true;
              model['requestReplacementStamp'] = '0';
              model['isReplacementRegister'] = true;
              model['isIssuanceStamp'] = false;
              // prefixName = "นาย";
            }),
          ),
        ),
        RadioListTile(
          contentPadding: const EdgeInsets.all(0),
          value: '2',
          groupValue: model['requestReplacementDoc'],
          title: const Text(
            "ชำรุด ในสาระสำคัญ",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 15.00,
                overflow: TextOverflow.ellipsis),
          ),
          activeColor: const Color(0xFF758C29),
          onChanged: (value) => setState(
            (() {
              model['requestReplacementDoc'] = '2';
              model['isEvidenceNotificationFile'] = false;
              model['evidenceNotificationFile'] = '';
              model['requestReplacementStamp'] = '0';
              model['isReplacementRegister'] = true;
              model['isIssuanceStamp'] = false;
              // prefixName = "นาย";
            }),
          ),
        ),
        model['requestReplacementDoc'] == '2'
            ? Padding(
                padding: const EdgeInsets.only(left: 55),
                child: textFieldReport(
                  // label: (model['requestReplacementDocDes'] ?? '') == '' ? 'กรอกรายละเอียด' : '',
                  hintText: 'กรอกรายละเอียด',
                  model: model['requestReplacementDocDes'] ?? '',
                  onChanged: (value) {
                    setState(() {
                      model['requestReplacementDocDes'] = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                  },
                ),
              )
            : Container(),
        const Text(
          '2.2 ขอรับตราประทับแทนตราประทับเดิม เนื่องจาก',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        RadioListTile(
          contentPadding: const EdgeInsets.all(0),
          value: '1',
          groupValue: model['requestReplacementStamp'],
          title: const Text(
            "สูญหาย",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 15.00,
                overflow: TextOverflow.ellipsis),
          ),
          activeColor: const Color(0xFF758C29),
          onChanged: (value) => setState(
            (() {
              model['requestReplacementStamp'] = '1';
              model['requestReplacementDoc'] = '0';
              model['isReplacementRegister'] = false;
              model['isIssuanceStamp'] = true;
              // prefixName = "นาย";
            }),
          ),
        ),
        RadioListTile(
          contentPadding: const EdgeInsets.all(0),
          value: '2',
          groupValue: model['requestReplacementStamp'],
          title: const Text(
            "ชำรุด ในสาระสำคัญ",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 15.00,
                overflow: TextOverflow.ellipsis),
          ),
          activeColor: const Color(0xFF758C29),
          onChanged: (value) => setState(
            (() {
              model['requestReplacementStamp'] = '2';
              model['requestReplacementDoc'] = '0';
              model['isReplacementRegister'] = false;
              model['isIssuanceStamp'] = true;
              // prefixName = "นาย";
            }),
          ),
        ),
        model['requestReplacementStamp'] == '2'
            ? Padding(
                padding: const EdgeInsets.only(left: 55),
                child: textFieldReport(
                  // label: (model['requestReplacementDocDes'] ?? '') == '' ? 'กรอกรายละเอียด' : '',
                  hintText: 'กรอกรายละเอียด',
                  model: model['requestReplacementStampDes'] ?? '',
                  onChanged: (value) {
                    setState(() {
                      model['requestReplacementStampDes'] = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                  },
                ),
              )
            : Container(),
        const SizedBox(
          height: 25,
        ),
        const Text(
          '3. พร้อมกับคำขอนี้ ข้าพเจ้าได้แนบหลักฐานต่างๆ มาด้วย คือ',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        CheckBoxAttachFile(
            title: 'ใบสำคัญฉบับเดิม (ถ้ามี)',
            value: model['isOriginalCerFile'] ?? false,
            file: model['originalCerFile'],
            onChange: (param) {
              setState(() {
                model['isOriginalCerFile'] = !model['isOriginalCerFile'];
                if (param == false) {
                  model['originalCerFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['originalCerFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['originalCerFile'] = '';
              });
            }),
        CheckBoxAttachFile(
            title: 'ตราประทับเดิม (ถ้ามี)',
            value: model['isOriginalSealFile'] ?? false,
            file: model['originalSealFile'],
            onChange: (param) {
              setState(() {
                model['isOriginalSealFile'] = !model['isOriginalSealFile'];
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['originalSealFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['originalSealFile'] = '';
              });
            }),
        CheckBoxAttachFile(
            title: 'หนังสือมอบอำนาจให้ยื่นคำขอแทน',
            value: model['isProxyFile'] ?? false,
            file: model['proxyFile'],
            onChange: (param) {
              setState(() {
                model['isProxyFile'] = !model['isProxyFile'];
                if (param == false) {
                  model['proxyFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['proxyFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['proxyFile'] = '';
              });
            }),
        CheckBoxAttachFile(
            title: 'รูปถ่ายสีสวมชุดครุยเนติบัณฑิต ขนาด 2 นิ้ว',
            value: model['isReplacementRegister'] ? true : false,
            file: model['photoGraduationFile'],
            isImage: true,
            isSelected: model['isReplacementRegister'] ? true : false,
            onChange: (param) {
              setState(() {
                model['isPhotoGraduationFile'] =
                    !model['isPhotoGraduationFile'];
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
              setState(() {
                model['photoGraduationFile'] = '';
              });
            }),
        CheckBoxAttachFile(
            title: 'หลักฐานการแจ้งความในใบสำคัญและหรือตราประทับสูญหาย',
            value: model['isReplacementRegister'] ? true : false,
            file: model['evidenceNotificationFile'],
            isSelected: model['isReplacementRegister'] ? true : false,
            onChange: (param) {
              setState(() {
                model['isEvidenceNotificationFile'] =
                    !model['isEvidenceNotificationFile'];
                if (param == false) {
                  model['evidenceNotificationFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['evidenceNotificationFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['evidenceNotificationFile'] = '';
              });
            }),
        CheckBoxAttachFile(
            title:
                'สำเนาบัตรประจำตัวสมาชิกสภาทนายความ หรือสำเนาใบอนุญาตให้เป็นทนายความ',
            value: true,
            file: model['copyLawyersMemberFile'],
            isSelected: true,
            onChange: (param) {
              setState(() {
                model['isCopyLawyersMemberFile'] =
                    !model['isCopyLawyersMemberFile'];
                if (param == false) {
                  model['copyLawyersMemberFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['copyLawyersMemberFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['copyLawyersMemberFile'] = '';
              });
            }),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'แนบไฟล์ลายมือชื่อ',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        AttachFile(
            value: true,
            file: model['licenseFile'],
            onChange: (param) {
              setState(() {
                // model['isCopyLawyersMemberFile'] =
                //     !model['isCopyLawyersMemberFile'];
                if (param == false) {
                  model['licenseFile'] = '';
                }
              });
            },
            onSelectFile: (param) {
              setState(() {
                model['licenseFile'] = param;
              });
            },
            onRemoveFile: (param) {
              setState(() {
                model['licenseFile'] = '';
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
              if (validate) {
                if ((model['requestReplacementDoc'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['requestReplacementStamp'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isOriginalCerFile'] ?? true) &&
                    (model['originalCerFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isOriginalSealFile'] ?? true) &&
                    (model['originalSealFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isProxyFile'] ?? true) &&
                    (model['proxyFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['photoGraduationFile'] ?? '') == '' &&
                    (model['isReplacementRegister'] == true)) {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['isReplacementRegister'] == true) &&
                    (model['evidenceNotificationFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['copyLawyersMemberFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ให้ครบ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if ((model['licenseFile'] ?? '') == '') {
                  Fluttertoast.showToast(
                    msg: 'กรุณาแนบไฟล์ลายมือชื่อ',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else if (model['isReplacementRegister'] != true &&
                    model['isIssuanceStamp'] != true) {
                  Fluttertoast.showToast(
                    msg: 'กรุณาเลือกความประสงค์',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                } else {
                  // setState(() => {page = 2});
                  _save();
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

  dialogOpenPickerDate({
    Function(String)? callBack,
  }) {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: const dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF758C29),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF758C29),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF758C29),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(3000),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;

          // ส่งค่ากลับเป็น String โดยใช้ DateFormat
          String formattedDate = DateFormat("dd-MM-yyyy").format(date);
          if (callBack != null) {
            callBack(
                formattedDate); // เรียกใช้งาน callback ด้วยค่าที่เป็น String
          }
        });
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

  Future getImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      // ทำการใช้งานไฟล์ที่เลือก เช่น result.files.first.path
      print('Selected file: ${result.files.single.path}');
    } else {
      // ผู้ใช้ไม่ได้เลือกไฟล์
      print('No file selected');
    }
  }

  // ignore: non_constant_identifier_names
  Widget CheckBoxAttachFile({
    String title = "",
    required Function(bool) onChange,
    required Function(String) onSelectFile,
    required Function(String) onRemoveFile,
    bool value = false,
    String? file,
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
            style: const TextStyle(
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
                      (file ?? '') != ''
                          ? Expanded(
                              child: isImage
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      height: 150,
                                      child: Stack(
                                        children: [
                                          file!.toLowerCase().endsWith('.pdf')
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
                                        color: const Color.fromARGB(
                                            117, 128, 153, 47),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              file!.split('/').last.toString(),
                                              style: const TextStyle(
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
                                    color:
                                        const Color.fromARGB(117, 128, 153, 47),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_file,
                                        size: 20,
                                      ),
                                      Text(
                                        isImage ? 'แนบรูปภาพ' : 'แนบไฟล์',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Kanit',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (file ?? '') == ''
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          isImage
                                              ? 'กรุณาแนบรูปภาพ'
                                              : 'กรุณาแนบไฟล์',
                                          style: const TextStyle(
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

  Widget AttachFile({
    required Function(bool) onChange,
    required Function(String) onSelectFile,
    required Function(String) onRemoveFile,
    bool value = false,
    String? file,
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
                                      file!,
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
                                        file?.split('/').last ?? '',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Kanit',
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                  style: const TextStyle(
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
                                    style: const TextStyle(
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

  // ignore: missing_return
  Future<String> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    try {
      if (result != null) {
        // Get the first file
        String? filePath = result.files.single.path;

        if (filePath != null) {
          // Create an XFile from the file path
          XFile file = XFile(filePath);

          // Now you can pass `xFile` to the function that expects an XFile
          return uploadImageX(file);
        } else {
          // If no file path is found, throw an error or return a default value
          throw 'No file path found';
        }
      } else {
        // If no file is selected, throw an error or return a default value
        throw 'No file selected';
      }
    } catch (e) {
      // Handle the error appropriately, for now, we throw it
      throw 'Error uploading file: $e';
    }
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
                  leading: const Icon(Icons.upload_file),
                  title: const Text(
                    'ไฟล์ในเครื่อง',
                    style: TextStyle(
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
                  leading: const Icon(Icons.photo_library),
                  title: const Text(
                    'อัลบั้มรูปภาพ',
                    style: TextStyle(
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
                  leading: const Icon(Icons.photo_camera),
                  title: const Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
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
    // ignore: no_leading_underscores_for_local_identifiers
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
}

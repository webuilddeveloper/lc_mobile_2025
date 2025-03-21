import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VolunteeLawyerFrom extends StatefulWidget {
  const VolunteeLawyerFrom({
    super.key,
    this.code,
    this.imageUrl,
  });

  final String? code;
  final String? imageUrl;

  @override
  // ignore: library_private_types_in_public_api
  _VolunteeLawyerFrom createState() => _VolunteeLawyerFrom();
}

class _VolunteeLawyerFrom extends State<VolunteeLawyerFrom> {
  ScrollController scrollController = ScrollController();

  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();
  bool isShowMap = true;
  late XFile _image;
  final List<dynamic> _itemImage = [];
  String profileCode = '';
  late Future<dynamic> _futureProfile;
  dynamic _profile;
  List<dynamic> _itemPlace = [];
  late String _selectedPlace;
  String reference = '';

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var dateString = DateFormat('yyyyMMdd').format(date).toString();
    print(dateString);
    reference = profileCode + '-' + dateString + '070000';
    print(reference);
    _futureProfile = postDio(profileReadApi, {'code': profileCode});
    _profile = await _futureProfile;
    getPlace();
  }

  Future<dynamic> getPlace() async {
    print(reference);
    final result = await postObjectData('m/v2/volunteeLawyer/checkin/read', {
      'profileCode': profileCode,
      'reference': reference,
      // 'reference': '20210216111726-103-860-20220616070000',
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPlace = result['objectData'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          flexibleSpace: Container(
            height: MediaQuery.of(context).padding.top + 60,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              right: 10,
              bottom: 10,
              left: 10,
            ),
            color: Colors.white,
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'รายละเอียดงาน',
                    style: TextStyle(
                      color: Color(0xFF011895),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/box_arrow_left.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                color: Colors.white,
                child: contentCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            const Text(
              '* หัวข้อ',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF011895),
              ),
            ),
            const SizedBox(height: 5),
            textFormField(
              txtTitle,
              'null',
              'กรุณาใส่หัวข้อคำปรึกษา',
              'หัวข้อ',
              true,
              false,
              false,
              false,
            ),
            const SizedBox(height: 25),
            const Text(
              '* รายละเอียด',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF011895),
              ),
            ),
            const SizedBox(height: 5),
            textFormFieldDescription(),
            buttonAddImage(),
            if (_itemImage.isNotEmpty) containerShowImage(),
            const SizedBox(height: 25),
            const Text(
              '* สถานที่',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF011895),
              ),
            ),
            const SizedBox(height: 5),
            selectedPlace(),
            const SizedBox(height: 25),
            buttonSave(),
          ],
        ),
      ),
    );
  }

  containerShowImage() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1,
        ),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: _itemImage.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 5.0),
            width: 400,
            child: MaterialButton(
              onPressed: () {
                dialogDeleteImage(_itemImage[index]['id'].toString());
              },
              child: Image.network(
                _itemImage[index]['imageUrl'],
                width: 1000,
                fit: BoxFit.cover,
              ),
              // ),
            ),
          );
        },
      ),
    );
  }

  buttonAddImage() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDDDDDD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: InkWell(
          onTap: () => _showPickerImage(context),
          child: Row(
            children: [
              Image.asset(
                'assets/images/metro-file-picture.png',
                height: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'รูปภาพ',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectedPlace() {
    return Container(
      width: 5000.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: (_selectedPlace != '')
          ? DropdownButtonFormField(
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              validator: (value) =>
                  value == '' || value == null ? 'กรุณาเลือกสถานที่' : null,
              // hint: Text(
              //   'จังหวัด',
              //   style: TextStyle(
              //     fontSize: 15.00,
              //     fontFamily: 'Kanit',
              //   ),
              // ),
              value: _selectedPlace,
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
              },
              onChanged: (newValue) {
                setState(() {
                  _selectedPlace = newValue as String;
                });
              },
              items: _itemPlace.map((item) {
                return DropdownMenuItem(
                  value: item['code'],
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 15.00,
                      fontFamily: 'Kanit',
                      color: Color(0xFF1B6CA8),
                    ),
                  ),
                );
              }).toList(),
            )
          : DropdownButtonFormField(
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              validator: (value) =>
                  value == '' || value == null ? 'กรุณาเลือกจังหวัด' : null,
              onChanged: (newValue) {
                setState(() {
                  _selectedPlace = newValue as String;
                });
              },
              items: _itemPlace.map((item) {
                return DropdownMenuItem(
                  value: item['code'],
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 15.00,
                      fontFamily: 'Kanit',
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  textFormField(
    TextEditingController model,
    String modelMatch,
    String hintText,
    String validator,
    bool enabled,
    bool isPassword,
    bool isEmail,
    bool isUserName,
  ) {
    return TextFormField(
      obscureText: isPassword,
      style: TextStyle(
        color: enabled ? const Color(0x7D000000) : const Color(0x7D000000),
        fontFamily: 'Kanit',
        fontSize: 13,
      ),
      inputFormatters: [
        if (isUserName || isPassword)
          FilteringTextInputFormatter.deny(RegExp(r'\s'))
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? const Color(0xFFF7F7F7) : const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        hintText: hintText,
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.amber, width: 0.5),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
      ),
      validator: (model) {
        if (model!.isEmpty) {
          return 'กรุณากรอก$validator.';
        }
        if (isPassword && model != modelMatch && modelMatch != null) {
          return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
        }
        if (isUserName) {
          String pattern = r'^[a-zA-Z0-9]+$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(model)) {
            return 'กรุณากรอกรูปแบบชื่อผู้ใช้งานให้ถูกต้อง.';
          }
        }
        if (isPassword) {
          // Pattern pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$';
          String pattern = r'^[a-zA-Z0-9]{6,}$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(model)) {
            return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
          }
        }
        if (isEmail) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(model)) {
            return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
          }
        }
        return null;
      },
      controller: model,
      enabled: enabled,
    );
  }

  textFormFieldDescription() {
    return TextFormField(
      style: const TextStyle(
        color: Color(0xFF4A4A4A),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 13,
      ),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xFFF7F7F7),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        hintText: 'กรุณาใส่รายละเอียด หรือ แนบรูปภาพ',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 13,
        ),
      ),
      validator: (model) {
        if (model!.isEmpty) {
          return 'กรุณากรอกรายละเอียด.';
        }
        return null;
      },
      controller: txtDescription,
      enabled: true,
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: null,
    );
  }

  buttonSave() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          color: const Color(0XFFED6B2D),
          child: MaterialButton(
            height: 40,
            onPressed: () {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();
                submit();
              }
            },
            child: const Text(
              'บันทึก',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  dialogDeleteImage(String code) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: const Text(''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              'ยกเลิก',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              'ลบ',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              deleteImage(code);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteImage(String code) async {
    setState(() {
      _itemImage.removeWhere((c) => c['id'].toString() == code.toString());
    });
  }

  _imgFromCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  void _upload() async {
    if (_image == null) return;

    Random random = Random();
    uploadImageX(_image).then((res) {
      setState(() {
        _itemImage.add({'imageUrl': res, 'id': random.nextInt(100)});
      });
      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      print(err);
    });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
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
                    _imgFromGallery();
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
                    _imgFromCamera();
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

  Future<dynamic> submit() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);
    var profileCode = await storage.read(key: 'profileCode18');

    var data = {
      'title': txtTitle.text,
      'description': txtDescription.text,
      'platform': Platform.operatingSystem.toString(),
      'profileCode': profileCode,
      'createBy': user['username'] ?? '',
      'imageUrlCreateBy': user['imageUrl'] ?? '',
      'imageUrl': widget.imageUrl ?? '',
      'lv0': user['lv0'],
      'lv1': user['lv1'],
      'lv2': user['lv2'],
      'lv3': user['lv3'],
      'lv4': user['lv4'],
      'gallery': _itemImage,
      'codePlace': _selectedPlace,
    };
    print(data);

    final result = await postObjectData('m/v2/VolunteeLawyer/create', data);
    print(result['objectData']);

    if (result['status'] == 'S') {
      return _dialogQR(result['objectData']['code']);
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: const Text(
                'บันทึกข้อมูลไม่สำเร็จ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(
                result['message'],
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
  //

  _dialogQR(code) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: CupertinoAlertDialog(
            // title: new Text(

            //   'บันทึกข้อมูลเรียบร้อยแล้ว',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontFamily: 'Kanit',
            //     color: Colors.black,
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
            content: Container(
              height: 200,
              color: Colors.white,
              alignment: Alignment.center,
              child: QrImageView(
                data:
                    'http://122.155.223.63/td-lc-font/assessment.html?pf=$profileCode&rf=' +
                        code,
                version: QrVersions.auto,
                size: 200,
                gapless: false,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Container(
                  width: 250,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6B2D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _dialogSuccess();
                  // goBack();/
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _dialogSuccess() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CupertinoAlertDialog(
            title: const Text(
              'บันทึกข้อมูลเรียบร้อยแล้ว',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: const Text(' '),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(
                  'ตกลง',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF005C9E),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  goBack();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

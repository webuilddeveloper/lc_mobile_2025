import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/material/button_full.dart';
import 'package:lc/component/material/input_with_label.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/shared/api_provider.dart';

class QuestionForm extends StatefulWidget {
  QuestionForm({Key? key, this.menuModel}) : super(key: key);

  final dynamic menuModel;

  @override
  QuestionFormState createState() => QuestionFormState();
}

class QuestionFormState extends State<QuestionForm> {
  late XFile _image;
  List<dynamic> items = [];
  List<String> _itemImage = [];
  String profileCode = '';
  String profileImageUrl = '';
  String profileFirstName = '';
  String profileLastName = '';
  bool showLoadingImage = false;

  final titleEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    getStorage();
    super.initState();
  }

  getStorage() async {
    final storage = new FlutterSecureStorage();
    var code = await storage.read(key: 'profileCode18');
    var imageUrl = await storage.read(key: 'profileImageUrl');
    var firstName = await storage.read(key: 'profileFirstName');
    var lastName = await storage.read(key: 'profileLastName');
    setState(() {
      profileCode = code!;
      profileImageUrl = imageUrl!;
      profileFirstName = firstName!;
      profileLastName = lastName!;
    });
  }

  void validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        backgroundColor: Color(0xFFFAFAF9),
        appBar: header(context, () => {Navigator.pop(context)},
            title: widget.menuModel['title']),
        body: new InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: screen(),
              ),
              showLoadingImage
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  screen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputWithLabel(
                context: context,
                title: 'หัวข้อ',
                hintText: '',
                textEditingController: titleEditingController,
                checkText: titleEditingController.text == '' ? true : false,
                hasBorder: true,
                maxLength: 100,
                callback: () {},
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกหัวข้อ.';
                  } else {
                    return null;
                  }
                }),
            SizedBox(height: 40.0),
            inputWithLabel(
                context: context,
                title: 'รายละเอียด',
                hintText: '',
                textEditingController: descriptionEditingController,
                checkText:
                    descriptionEditingController.text == '' ? false : true,
                hasBorder: true,
                callback: () {},
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (String value) {
                  print(value);
                  if (value.isEmpty) {
                    return 'กรุณากรอกรายละเอียด.';
                  } else {
                    return null;
                  }
                }),
            SizedBox(height: 40.0),
            // ImageUploadPicker(
            //   callback: (File item, List<dynamic> items) {
            //     setState(() {
            //       _image = item;
            //       _itemImage = items;
            //     });
            //   },
            // ),
            imagePicker(),
            SizedBox(height: 40.0),
            buttonFull(
              title: 'ตั้งคำถาม',
              width: 284,
              fontSize: 20,
              elevation: 0.0,
              fontWeight: FontWeight.w500,
              backgroundColor: Theme.of(context).primaryColor,
              fontColor: Colors.white,
              callback: () {
                FocusScope.of(context).unfocus();
                validateAndSave();
                create();
              },
            ),
          ],
        ),
      ),
    );
  }

  create() async {
    if (titleEditingController.text != '' &&
        descriptionEditingController.text != '') {
      try {
        await post(questionApi + 'create', {
          'title': titleEditingController.text,
          'description': descriptionEditingController.text,
          'imageList': _itemImage,
          'createBy': profileFirstName + ' ' + profileLastName,
          'profileCode': profileCode
        }).then((value) => {Navigator.pop(context)});
      } catch (ex) {
        return toastFail(context);
      }
    }
  }

  imagePicker() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เพิ่มรูปภาพ',
                    style: TextStyle(
                      fontSize: 20.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '(สามารถอัพโหลดรูปภาพไม่เกิน 10 รูป)',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFA9151D),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (_itemImage.length < 10) {
                          _showPickerImage(context);
                        } else {
                          return toastFail(context,
                              text: 'สามารถอัพโหลดรูปภาพได้ไม่เกิน 10 รูป');
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Image.asset(
                        'assets/logo/icons/picture.png',
                        // height: 14.0,
                        width: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_itemImage.length > 0)
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1,
              ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _itemImage.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: 400,
                  child: MaterialButton(
                    onPressed: () {
                      dialogDeleteImage(_itemImage[index]);
                    },
                    child: Image.network(
                      'https://example.com/image.jpg',
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image has finished loading, return the child (image).
                          return child;
                        } else {
                          // Image is loading, show a progress indicator.
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(
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
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
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

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  deleteImage(String code) async {
    setState(() {
      _itemImage.removeWhere((c) => c == code);
    });
  }

  void _upload() async {
    if (_image == null) return;

    var id = new DateTime.now().millisecondsSinceEpoch;
    setState(() {
      showLoadingImage = true;
    });
    uploadImageX(_image).then((res) {
      setState(() {
        showLoadingImage = false;
        _itemImage.add(res);
      });
      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      setState(() {
        showLoadingImage = false;
      });
      print(err);
    });
  }

  dialogDeleteImage(String code) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: new Text(''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ยกเลิก",
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
            child: new Text(
              "ลบ",
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
  // .end
}

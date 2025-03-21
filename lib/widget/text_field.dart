import 'package:flutter/material.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' $label',
        style: const TextStyle(
          fontSize: 15.000,
          fontFamily: 'Kanit',
        ),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 45.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: const TextStyle(
        color: Color(0xFF6F0100),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFEEBA33),
        contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

textFieldReport(
    {String? model,
    String? hintText,
    String? label,
    Function(String)? validator,
    Function(String)? onChanged,
    bool enabled = true,
    bool isPassword = false,
    bool isGlobalKey = false,
    Key? key}) {
  return
      // SizedBox(
      //   height: model != '' ? 45.0 : 75.0,
      //   child:
      TextFormField(
    key: isGlobalKey ? GlobalKey(debugLabel: model.toString()) : null,
    // key: GlobalKey(debugLabel: model.toString()),
    // keyboardType: TextInputType.number,
    obscureText: isPassword,
    initialValue: model,

    // controller: TextEditingController(text: model.toString()),
    enabled: enabled,
    style: const TextStyle(
      color: Color(0xFF758C29),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 14.00,
    ),
    validator: (value) => validator!(value!),
    onChanged: (p) => onChanged!(p),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF758C29),
      ),
      errorStyle: const TextStyle(height: 0.8),
      filled: true,
      fillColor: enabled ? Colors.white : const Color(0xFFDDDDDD),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF758C29),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        // borderSide: BorderSide(
        //   color: Color(0xFF758C29),
        // ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFF758C29),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 149, 180, 48),
        ),
      ),
    ),
    // ),
  );
}

dropdownFieldReport(
    {String? hintText,
    bool? enabled = true,
    List<dynamic>? listItem,
    Function(String)? validator,
    String? value,
    String? label,
    required Function(String) onChanged,
    required Function() onTap}) {
  return
      // SizedBox(
      //   height: 45.0,
      //   child:
      AbsorbPointer(
    absorbing: !enabled!,
    child: DropdownButtonFormField(
      isExpanded: true,
      style: const TextStyle(
          color: Color(0xFF758C29),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 15.00,
          overflow: TextOverflow.ellipsis),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF758C29),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFDDDDDD),
        contentPadding: const EdgeInsets.fromLTRB(25.0, 5.0, 5.0, 5.0),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF758C29),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.5),
          // borderSide: BorderSide(
          //   color: Colors.white,
          // ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.5),
          borderSide: BorderSide(
            color: enabled ? const Color(0xFF758C29) : const Color(0xFFDDDDDD),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.5),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 149, 180, 48),
          ),
        ),
      ),
      validator: (value) => validator!(value.toString()),
      value: value,
      // onTap: enabled ? onTap : null,
      onChanged: (newValue) => onChanged(newValue.toString()),
      items: listItem?.map((item) {
        return DropdownMenuItem(
          value: item['title'],
          child: Text(
            item['title'],
            style: const TextStyle(
                fontSize: 15.00,
                fontFamily: 'Kanit',
                color: Color(0xFF758C29),
                overflow: TextOverflow.ellipsis),
          ),
        );
      }).toList(),
    ),
    // ),
  );
}

import 'package:flutter/material.dart';

class DataError extends StatefulWidget {
  const DataError(
      {super.key, this.height = 100, this.onTap, this.color = Colors.black});

  final double height;
  final VoidCallback? onTap; // Change from Function? to VoidCallback?
  final Color color;

  @override
  // ignore: library_private_types_in_public_api
  _DataErrorState createState() => _DataErrorState();
}

class _DataErrorState extends State<DataError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, color: widget.color),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onTap, // onTap is now of type VoidCallback?
                child: Text(
                  'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                  style: TextStyle(color: widget.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          widget.onTap != null
              ? IconButton(
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 30,
                  ),
                  onPressed: widget
                      .onTap, // onPressed is now compatible with VoidCallback
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

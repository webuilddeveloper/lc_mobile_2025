// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class LawyerResultOfVoteCountingListVertical extends StatefulWidget {
  const LawyerResultOfVoteCountingListVertical({
    super.key,
    this.model,
    required this.title,
  });

  final dynamic model;
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerResultOfVoteCountingListVertical createState() =>
      _LawyerResultOfVoteCountingListVertical();
}

class _LawyerResultOfVoteCountingListVertical
    extends State<LawyerResultOfVoteCountingListVertical> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.model.length,
      itemBuilder: (context, index) {
        if (widget.title == 'ผู้สมัครนายก') {
          return myCardPrimeCandidate(index, widget.model[index], context);
        } else {
          return myCardDirectorCandidate(index, widget.model[index], context);
        }
      },
    );
  }

  myCardPrimeCandidate(int index, dynamic model, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 30,
                    child: Text(
                      '${model['numberCandidate']}',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 50,
                    child: Text(
                      model['scoreCandidate'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            index < 3
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        model['imageUrl'],
                        height: 55,
                        width: 55,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  myCardDirectorCandidate(int index, dynamic model, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 30,
                    child: Text(
                      '${model['numberBoard']}',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 50,
                    child: Text(
                      model['scoreBoard'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //
}

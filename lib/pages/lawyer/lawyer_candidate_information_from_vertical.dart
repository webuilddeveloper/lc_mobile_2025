import 'package:flutter/material.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_from.dart';

class LawyerCandidateInformationFromVertical extends StatefulWidget {
  const LawyerCandidateInformationFromVertical({
    super.key,
    this.model,
    required this.title,
  });

  final dynamic model;
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerCandidateInformationFromVertical createState() =>
      _LawyerCandidateInformationFromVertical();
}

class _LawyerCandidateInformationFromVertical
    extends State<LawyerCandidateInformationFromVertical> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        mainAxisSpacing: 15,
      ),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.model.length,
      itemBuilder: (context, index) {
        return myCardDirectorCandidate(index, widget.model[index], context);
      },
    );
  }

  myCardDirectorCandidate(int index, dynamic model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerCandidateInformationFrom(
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: index % 4 == 0
            ? const EdgeInsets.only(right: 4)
            : index % 4 == 1
                ? const EdgeInsets.only(left: 4, right: 4)
                : index % 4 == 2
                    ? const EdgeInsets.only(left: 4, right: 4)
                    : const EdgeInsets.only(left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  model['imageUrl'],
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'หมายเลข ${model['numberBoard']}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF011895),
                fontFamily: 'Kanit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
}

import 'package:flutter/material.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_from.dart';

class LawyerCandidateInformationListVertical extends StatefulWidget {
  const LawyerCandidateInformationListVertical({
    super.key,
    this.model,
  });

  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerCandidateInformationListVertical createState() =>
      _LawyerCandidateInformationListVertical();
}

class _LawyerCandidateInformationListVertical
    extends State<LawyerCandidateInformationListVertical> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerCandidateInformationFrom(
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: index % 3 == 0
            ? const EdgeInsets.only(right: 7.5, left: 15)
            : index % 3 == 1
                ? const EdgeInsets.only(right: 7.5, left: 7.5)
                : const EdgeInsets.only(left: 7.5, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  model['imageUrl'],
                  height: 108,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                'หมายเลข ${model['numberBoard']}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF011895),
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            Text(
              '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF000000),
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500),
            ),
            Text(
              '${model['affiliation']}',
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF000000),
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

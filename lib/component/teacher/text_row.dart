import 'package:flutter/material.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_list.dart';
import 'package:lc/pages/lawyer/lawyer_result_of_vote_counting_list.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURLMap(String lat, String lng) async {
  String homeLat = lat;
  String homeLng = lng;

  final String googleMapslocationUrl =
      // ignore: prefer_interpolation_to_compose_strings
      "https://www.google.com/maps/search/?api=1&query=" +
          homeLat +
          ',' +
          homeLng;

  final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

  launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);

  // if (await canLaunch(encodedURl)) {
  //   await launch(encodedURl);
  // } else {
  //   throw 'Could not launch $encodedURl';
  // }
}

Container textRow(BuildContext context,
    {String title = '', String value = ''}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        SizedBox(
          width: 135.0,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
          ),
        ),
        Expanded(
          child: Text(
            value != '' && value != 'null' ? value : '-',
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D9CED),
            ),
            // maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

Container textRowGo(
  BuildContext context, {
  String title = '',
  String value = '',
  String typeBtn = '',
  String? lat,
  String? lng,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        SizedBox(
          width: 135.0,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
          ),
        ),
        InkWell(
          onTap: () => typeBtn != ''
              ? typeBtn == 'googlemap'
                  ? launchURLMap(lat!, lng!)
                  : null
              : null,
          child: Row(
            children: [
              Text(
                value != '' && value != 'null' ? value : '-',
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D9CED),
                  decoration: TextDecoration.underline,
                ),
                // maxLines: 2,
              ),
              const SizedBox(width: 10),
              Image.asset(
                "assets/logo/icons/rightGo.png",
                height: 15,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Container textRowButtonGo(
  BuildContext context, {
  String title = '',
  String value = '',
  String typeBtn = '',
  double fontSize = 15.0,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: InkWell(
      onTap: () => typeBtn != ''
          ? typeBtn == 'link'
              ? launchInWebViewWithJavaScript(value)
              : typeBtn == 'pageCI'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyerCandidateInformationList(),
                      ),
                    )
                  : typeBtn == 'pageRVOC'
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LawyerResultOfVoteCountingList(),
                          ),
                        )
                      : null
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 210,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
            ),
          ),
          Image.asset(
            "assets/logo/icons/buttonRightGo.png",
            width: 30,
          ),
        ],
      ),
    ),
  );
}

Container textRow2(BuildContext context,
    {String title = '', String value = ''}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        SizedBox(
          width: 40.0,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
          ),
        ),
        Expanded(
          child: Text(
            value != '' && value != 'null' ? value : '-',
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
            // maxLines: 2,
          ),
        ),
      ],
    ),
  );
}
//

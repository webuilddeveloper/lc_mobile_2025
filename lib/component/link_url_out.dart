import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

import 'package:url_launcher/url_launcher.dart';

class LinkUtils {
  LinkUtils._();

  static Future<void> openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Colud not open this url';
    }
  }
}

import 'package:url_launcher/url_launcher.dart';

abstract class AppLauncher {
  static void launchPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  static void launchWhatsApp(String phoneNumber) async {
    String formattedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (formattedPhone.startsWith('0')) {
      formattedPhone = '20${formattedPhone.substring(1)}';
    }
    final Uri url = Uri.parse("whatsapp://send?phone=$formattedPhone");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

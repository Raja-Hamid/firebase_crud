import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:firebase_crud/controllers/routes/app_routes.dart';
class AppLinksService {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> initAppLinks() async {
    final uri = await _appLinks.getInitialLink();
    _handleAppLink(uri);

    _appLinks.uriLinkStream.listen((Uri? uri) {
      _handleAppLink(uri);
    });
  }

  static void _handleAppLink(Uri? uri) {
    if (uri != null) {
      final allParams = uri.queryParameters;
      if (allParams.containsKey('mode') && allParams['mode'] == 'resetPassword') {
        final oobCode = allParams['oobCode'];
        if (oobCode?.isNotEmpty == true) {
          Get.toNamed(AppRoutes.newPasswordScreen, arguments: oobCode);
        }
      }
    }
  }
}

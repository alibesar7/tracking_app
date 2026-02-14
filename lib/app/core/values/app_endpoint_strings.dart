class AppEndpointString {
  static const String baseUrl = 'https://flower.elevateegy.com/api/v1/';
  static const String loginEndpoint = 'auth/signin';
  static const String sendEmail = 'drivers/forgotPassword';
  static const String verifyResetCode = 'drivers/verifyResetCode';
  static const String resetPassword = 'drivers/resetPassword';

  static const String profileData = 'auth/profile-data';
  static const String uploadPhoto = 'auth/upload-photo';
  static const String logout = 'auth/logout';
  static const String updateRole = 'auth/update-role';

  static const String cashOrder = 'orders';
  static const String orders = 'orders';
  static const String checkout = '$orders/checkout';
  static const String addresses = 'addresses';
  static const String signup = '/auth/signup';
  static const String allCategories = 'categories';
  static const String getProduct = '/products';
  static const String home = '/home';
  static const String productDetails = 'products/{id}';
  static const String cartPage = 'cart';
  static const String changePassword = "drivers/change-password";
  static const String tokenKey = 'token';
  static const String editProfile = 'auth/editProfile';
  static const String changepassword = 'auth/change-password';
  static const String addAddress = 'addresses';
  static const String getaddresses = 'addresses';
  static const String getNotifications = "notifications/user";
  static const String deleteSpecificNotification = "notifications/{id}";
  static const String deleteAllNotifications = "notifications/clear-all";
  static const String getVehicles = "vehicles";
  static const String apply = "drivers/apply";


}

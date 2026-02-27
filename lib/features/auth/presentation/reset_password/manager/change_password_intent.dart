sealed class ChangePasswordIntent {}

class CurrentPasswordIntent extends ChangePasswordIntent {
  final String? currentPass;
  CurrentPasswordIntent({this.currentPass});
}

class NewPasswordIntent extends ChangePasswordIntent {
  final String? newPass;
  NewPasswordIntent({this.newPass});
}

class ConfirmPasswordIntent extends ChangePasswordIntent {
  final String? confirmPass;
  ConfirmPasswordIntent({this.confirmPass});
}

class SubmitChangePasswordIntent extends ChangePasswordIntent {}

class FormValidIntent extends ChangePasswordIntent {}

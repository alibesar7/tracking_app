sealed class ChangePasswordIntent {
  const ChangePasswordIntent();

  static const formChanged = FormChangedIntent();
  static const togglePasswordVisibility = TogglePasswordVisibilityIntent();
  static const submit = SubmitChangePasswordIntent();
}

class FormChangedIntent extends ChangePasswordIntent {
  const FormChangedIntent();
}

class TogglePasswordVisibilityIntent extends ChangePasswordIntent {
  const TogglePasswordVisibilityIntent();
}

class SubmitChangePasswordIntent extends ChangePasswordIntent {
  const SubmitChangePasswordIntent();
}

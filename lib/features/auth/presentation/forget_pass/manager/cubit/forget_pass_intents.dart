part of 'forget_pass_cubit.dart';

sealed class ForgetPasswordIntents {
  const ForgetPasswordIntents();
}

class FormChangedIntent extends ForgetPasswordIntents {
  const FormChangedIntent();
}

class SubmitForgetPasswordIntent extends ForgetPasswordIntents {
  const SubmitForgetPasswordIntent();
}

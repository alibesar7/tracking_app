part of 'verify_reset_cubit.dart';

sealed class VerifyResetCodeIntents {
  const VerifyResetCodeIntents();
}

class FormChangedIntent extends VerifyResetCodeIntents {
  final String code;
  const FormChangedIntent(this.code);
}

class SubmitVerifyCodeIntent extends VerifyResetCodeIntents {
  const SubmitVerifyCodeIntent();
}

class ResendCodeIntent extends VerifyResetCodeIntents {
  const ResendCodeIntent();
}

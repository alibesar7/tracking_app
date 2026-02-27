import 'package:tracking_app/app/core/network/api_result.dart';

extension ApiResultPick<T> on ApiResult<T> {
  ApiResult<R> pick<R>(R Function(T) selector) {
    if (this is SuccessApiResult<T>) {
      final success = this as SuccessApiResult<T>;
      return SuccessApiResult<R>(data: selector(success.data));
    } else if (this is ErrorApiResult<T>) {
      final error = this as ErrorApiResult<T>;
      return ErrorApiResult<R>(error: error.error);
    } else {
      return ErrorApiResult<R>(error: "Unknown error");
    }
  }
}

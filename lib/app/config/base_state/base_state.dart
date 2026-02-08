enum Status { loading, success, error, initial }

class Resource<T> {
  final Status status;
  T? data;
  String? error;

  var message;
  Resource({required this.status, this.data, this.error});

  factory Resource.success(T? data) {
    return Resource<T>(status: Status.success, data: data);
  }
  factory Resource.loading() {
    return Resource<T>(status: Status.loading);
  }
  factory Resource.error(String error) {
    return Resource<T>(status: Status.error, error: error);
  }
  factory Resource.initial() {
    return Resource<T>(status: Status.initial);
  }

  bool get isSuccess => status == Status.success;
  bool get isLoading => status == Status.loading;
  bool get isError => status == Status.error;
  bool get isInitial => status == Status.initial;
}

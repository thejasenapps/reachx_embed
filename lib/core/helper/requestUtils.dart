enum RequestType { GET, POST, DELETE, PATCH }


class RequestTypeNotFoundException implements Exception {
  String cause;
  RequestTypeNotFoundException(this.cause);
}

class Nothing {
  Nothing._();
}

class Results<T> {
  Results._();

  factory Results.loading(T msg) = LoadingState<T>;
  factory Results.success(T value) = SuccessState<T>;
  factory Results.error(T msg) = ErrorState<T>;

}

class LoadingState<T> extends Results<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}

class ErrorState<T> extends Results<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends Results<T> {
  SuccessState(this.value) : super._();
  final T value;
}

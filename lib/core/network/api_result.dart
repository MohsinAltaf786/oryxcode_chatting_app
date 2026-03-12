abstract class AppApiResult<T>{
  AppApiResult();
}

class Success<T> implements AppApiResult{
  final T data;
  const Success(this.data);
}
class Failure<T> implements AppApiResult{
  final String error;
  const Failure(this.error);
}
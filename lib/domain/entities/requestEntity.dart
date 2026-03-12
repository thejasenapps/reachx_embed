
class RequestEntity {
  String requestId;
  String expertId;
  String userId;
  DateTime timestamp;

  RequestEntity({
    required this.requestId,
    required this.userId,
    required this.expertId,
    required this.timestamp
  });
}


class MultipleRequestsEntity  {
  List<RequestEntity> requests;

  MultipleRequestsEntity({
    required this.requests
  });
}
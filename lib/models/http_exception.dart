class HttpException implements Exception {
  final String Message;

  HttpException(this.Message);

  @override
  String toString() {
    // TODO: implement toString
    return Message;
  }
}

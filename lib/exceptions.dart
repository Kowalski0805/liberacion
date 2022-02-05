
class UnauthorizedException implements Exception {
  String errorMessage() {
    return '401 Unauthorized';
  }
}

class ForbiddenException implements Exception {
  String errorMessage() {
    return '403 Forbidden';
  }
}

class UnprocessableEntityException implements Exception {
  String errorMessage() {
    return '422 Unprocessable Entity';
  }
}
//Login
class UserNotFoundAuthException implements Exception {}

class WrongPassWordAuthException implements Exception {}

//Register
class WeakPassWordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class EmailInvalidAuthException implements Exception {}

//Generic
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

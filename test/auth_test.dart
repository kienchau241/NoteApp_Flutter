import 'package:flutterbegin1/services/auth/auth_exceptions.dart';
import 'package:flutterbegin1/services/auth/auth_provider.dart';
import 'package:flutterbegin1/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Provider', () {
    final provider = MockAuthProvider();
    test("Should not be initialized in begin with", () {
      expect(provider.isInitialize, false);
    });
    test('Cannot log out if not initialized', () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NoInitializedException>()));
    });
    test("Should be able to initialized ", () async {
      await provider.initialize();
      expect(provider.isInitialize, true);
    });
    test('User should be null after init', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to init in less than 3 secs',
      () async {
        await provider.initialize();
        expect(provider.isInitialize, true);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test('Create user should be delegate to login function', () async {
      final badEmail = provider.createUser(
        email: "kienchau241.com",
        password: "anypass",
      );
      expect(
        badEmail,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badPasswordUser = provider.createUser(
        email: "kienchau241@gmail.com",
        password: '12345',
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPassWordAuthException>()),
      );
      final user = await provider.createUser(email: "kien", password: "chau");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged user should able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logout();
      await provider.login(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NoInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialize => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialize) throw NoInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialize) throw NoInitializedException();
    if (email == "kienchau241.com") throw UserNotFoundAuthException();
    if (password == "12345") throw WrongPassWordAuthException();
    const user =
        AuthUser(isEmailVerified: false, email: 'kienchau241@gmail.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialize) throw NoInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialize) throw NoInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(isEmailVerified: true, email: 'kienchau241@gmail.com');
    _user = newUser;
  }
}

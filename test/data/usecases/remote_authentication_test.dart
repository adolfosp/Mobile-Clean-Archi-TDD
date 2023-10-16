import 'package:faker/faker.dart';
import 'package:mobile_clean_tdd/data/http/http.dart';
import 'package:mobile_clean_tdd/data/usecases/usescases.dart';
import 'package:mobile_clean_tdd/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mobile_clean_tdd/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((realInvocation) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('should call http client with correct values', () async {
    await sut.auth(params);

    //Assert
    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret})).called(1);
  });

  test('should throw UnexpectedError if httpClient returns 400', () async {
    //Arrange
    mockHttpError(HttpError.badRequest);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if httpClient returns 404', () async {
    //Arrange
    mockHttpError(HttpError.notFound);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if httpClient returns 500', () async {
    //Arrange
    mockHttpError(HttpError.serverError);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw invalidCredentialError if httpClient returns 401',
      () async {
    //Arrange
    mockHttpError(HttpError.unauthorized);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.invalidCredential));
  });

  test('should return an account if httpclient returns 200', () async {
    //Arrange
    final validData = mockValidData();
    mockHttpData(validData);

    //Act
    final account = await sut.auth(params);

    //Assert
    expect(account.token, validData['accessToken']);
  });

  test(
      'should throw unexpectedError if httpclient returns 200 with invalid data',
      () async {
    //Arrange
    mockHttpData({
      'invalid_key': 'accountToken',
    });

    //Act
    final account = sut.auth(params);

    //Assert
    expect(account, throwsA(DomainError.unexpected));
  });
}

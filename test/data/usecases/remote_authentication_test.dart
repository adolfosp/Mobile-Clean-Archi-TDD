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

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('should call http client with correct values', () async {
    //Act

    await sut.auth(params);

    //Assert
    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret})).called(1);
  });

  test('should throw UnexpectedError if httpClient returns 400', () async {
    //Arrange
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if httpClient returns 404', () async {
    //Arrange
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if httpClient returns 500', () async {
    //Arrange
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    //Act
    final future = sut.auth(params);

    //Assert
    expect(future, throwsA(DomainError.unexpected));
  });
}

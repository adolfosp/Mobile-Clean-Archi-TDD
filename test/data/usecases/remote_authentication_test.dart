import 'package:faker/faker.dart';
import 'package:mobile_clean_tdd/data/http/http.dart';
import 'package:mobile_clean_tdd/data/usecases/usescases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mobile_clean_tdd/domain/usecases/authentication.dart';



class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call http client with correct values', () async {
    //Act
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    //Assert
    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret})).called(1);
  });
}

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication{
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async{
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient{
  Future<void> request({ required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient{
}

void main() {

  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call http client with correct values', () async{
    //Act
    await sut.auth();

    //Assert
    verify(httpClient.request(url: url, method: 'post')).called(1);
  });
}
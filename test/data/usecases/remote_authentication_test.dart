import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication{
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async{
    await httpClient.request(url: url);
  }
}

abstract class HttpClient{
  Future<void> request({ required String url}) async{}
}

class HttpClientSpy extends Mock implements HttpClient{}

void main() {
  test('should call http client with correct URL', () async{
    //Arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    
    //Act
    await sut.auth();

    //Assert
    verify(httpClient.request(url: url));
  });
}
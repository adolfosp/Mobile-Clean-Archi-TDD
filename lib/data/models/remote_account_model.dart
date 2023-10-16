import 'package:mobile_clean_tdd/data/http/http.dart';
import 'package:mobile_clean_tdd/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }

    return RemoteAccountModel(json["accessToken"]);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}

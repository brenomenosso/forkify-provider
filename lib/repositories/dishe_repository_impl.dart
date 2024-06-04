import 'package:dio/dio.dart';
import 'package:forky_app_provider/exceptions/exceptions_message.dart';
import 'package:forky_app_provider/fp/either.dart';
import 'package:forky_app_provider/model/dishe.dart';
import 'package:forky_app_provider/repositories/dishe_repository.dart';
import 'package:forky_app_provider/restClient/api.dart';

class DisheRepositoryImpl implements DisheRepository {

  DisheRepositoryImpl();

  @override
  Future<Either<AuthException, List<Dishes>>> getDishes(String food) async {
    Api api = Api();

    try {
      final response = await api.doGet(endpoint: '/search?q=$food');
      final List<Dishes> dishes = (response['recipes'] as List).map((e) => Dishes.fromJson(e)).toList();
      return Right(dishes);
    } on DioException catch (e) {
      return Left(AuthError(message: e.message!));
    }
  }
}
import 'package:forky_app_provider/exceptions/exceptions_message.dart';
import 'package:forky_app_provider/fp/either.dart';
import 'package:forky_app_provider/model/dishe.dart';

abstract interface class DisheRepository {

  Future<Either<AuthException,List<Dishes>>> getDishes(String food);

}
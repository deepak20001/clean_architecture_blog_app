import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  /// every use-case will have just one func, as use-case are supposed to do just one task
  /// SuccessType and params can be different for each use-case so we can take them via generics
  Future<Either<Failure, SuccessType>> call(Params params);
}
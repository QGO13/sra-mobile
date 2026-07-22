abstract class UseCase<TypeResult, Params> {
  Future<TypeResult> call(Params params);
}

class NoParams {}


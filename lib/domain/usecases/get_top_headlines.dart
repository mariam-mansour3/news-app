import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines implements UseCase<List<Article>, NoParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) async {
    return await repository.getTopHeadlines();
  }
}

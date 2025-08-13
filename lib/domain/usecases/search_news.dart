import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class SearchNews implements UseCase<List<Article>, SearchParams> {
  final NewsRepository repository;

  SearchNews(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(SearchParams params) async {
    return await repository.searchNews(params.query);
  }
}

class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object> get props => [query];
}

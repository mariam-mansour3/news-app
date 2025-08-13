import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_top_headlines.dart';
import '../../domain/usecases/search_news.dart';

// Events
abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetTopHeadlinesEvent extends NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;

  const SearchNewsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadCachedNewsEvent extends NewsEvent {}

// States
abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool isFromCache;

  const NewsLoaded(this.articles, {this.isFromCache = false});

  @override
  List<Object> get props => [articles, isFromCache];
}

class NewsError extends NewsState {
  final String message;
  final bool hasCache;

  const NewsError(this.message, {this.hasCache = false});

  @override
  List<Object> get props => [message, hasCache];
}

// BLoC
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final SearchNews searchNews;

  NewsBloc({required this.getTopHeadlines, required this.searchNews})
      : super(NewsInitial()) {
    on<GetTopHeadlinesEvent>(_onGetTopHeadlines);
    on<SearchNewsEvent>(_onSearchNews);
    on<LoadCachedNewsEvent>(_onLoadCachedNews);
  }

  Future<void> _onGetTopHeadlines(
    GetTopHeadlinesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    final failureOrArticles = await getTopHeadlines(NoParams());

    failureOrArticles.fold((failure) {
      // If there's a failure, try to emit cached articles
      _loadCachedArticlesOnFailure(emit);
    }, (articles) => emit(NewsLoaded(articles)));
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    final failureOrArticles = await searchNews(
      SearchParams(query: event.query),
    );

    failureOrArticles.fold(
      (failure) => emit(const NewsError('Failed to search news')),
      (articles) => emit(NewsLoaded(articles)),
    );
  }

  Future<void> _onLoadCachedNews(
    LoadCachedNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    _loadCachedArticlesOnFailure(emit);
  }

  Future<void> _loadCachedArticlesOnFailure(Emitter<NewsState> emit) async {
    // Try to get cached articles when remote fails
    final failureOrCached = await getTopHeadlines(NoParams());
    failureOrCached.fold(
      (failure) => emit(
        const NewsError('Failed to fetch news and no cached data available'),
      ),
      (cachedArticles) {
        if (cachedArticles.isNotEmpty) {
          emit(NewsLoaded(cachedArticles, isFromCache: true));
        } else {
          emit(
            const NewsError(
              'Failed to fetch news and no cached data available',
            ),
          );
        }
      },
    );
  }
}

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import 'data/datasources/news_local_data_source.dart';
import 'data/datasources/news_remote_data_source.dart';
import 'data/repositories/news_repository_impl.dart';
import 'data/models/article_hive_model.dart';
import 'domain/repositories/news_repository.dart';
import 'domain/usecases/get_top_headlines.dart';
import 'domain/usecases/search_news.dart';
import 'presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ArticleHiveModelAdapter());
  }

  //! Features - News
  // Bloc
  sl.registerFactory(() => NewsBloc(getTopHeadlines: sl(), searchNews: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchNews(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}

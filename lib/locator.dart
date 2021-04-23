import 'package:get_it/get_it.dart';

import 'data/remote/api_service.dart';
import 'data/remote/source/remote_data_source.dart';
import 'domain/repository/IssueRepository.dart';
import 'domain/usecase/GetIssuesUseCase.dart';
import 'ui/home/issues/bloc/issues_bloc.dart';

final getIt = GetIt.instance;

void setup() {
	getIt.registerSingleton<ApiService>(ApiService());

	getIt.registerSingleton<RemoteDataSource>(RemoteDataSourceImpl(getIt<ApiService>()));

	getIt.registerSingleton<IssueRepository>(IssueRepositoryImpl(getIt<RemoteDataSource>()));

	getIt.registerSingleton<GetIssuesUseCase>(GetIssuesUseCase(getIt<IssueRepository>()));

	getIt.registerFactory(() => IssuesBloc(getIt<GetIssuesUseCase>()));
}
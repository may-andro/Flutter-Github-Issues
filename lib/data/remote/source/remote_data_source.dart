import 'package:flutter_github/data/remote/model/issue_item.dart';

import '../api_service.dart';

abstract class RemoteDataSource {
  Future<List<IssueItem>> getAllIssues(bool isOpen);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  ApiService apiService;

  RemoteDataSourceImpl(this.apiService);

  @override
  Future<List<IssueItem>> getAllIssues(bool isOpen) => apiService.fetchIssues(isOpen);
}

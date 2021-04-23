import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/data/remote/source/remote_data_source.dart';

abstract class IssueRepository {
	Future<List<IssueItem>> getAllIssues(bool isOpen);
}

class IssueRepositoryImpl implements IssueRepository {
	RemoteDataSource remoteDataSource;

	IssueRepositoryImpl(this.remoteDataSource);

	@override
	Future<List<IssueItem>> getAllIssues(bool isOpen) => remoteDataSource.getAllIssues(isOpen);
}

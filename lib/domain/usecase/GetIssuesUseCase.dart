import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/domain/repository/IssueRepository.dart';

abstract class UseCase<Param, T> {
	Future<T> execute(Param param);
}

class GetIssuesUseCase implements UseCase<bool, List<IssueItem>> {
	IssueRepository issueRepository;

	GetIssuesUseCase(this.issueRepository);

	@override
	Future<List<IssueItem>> execute(bool param) => issueRepository.getAllIssues(param);
}
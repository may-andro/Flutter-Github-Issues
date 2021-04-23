import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/domain/usecase/GetIssuesUseCase.dart';
import 'package:rxdart/rxdart.dart';

class IssuesBloc {
  GetIssuesUseCase getIssuesUseCase;

  IssuesBloc(this.getIssuesUseCase);

  final _issuesSubject = PublishSubject<List<IssueItem>>();
  Stream<List<IssueItem>> get allIssuesStream => _issuesSubject.stream;
  Sink<List<IssueItem>> get allIssuesSink => _issuesSubject.sink;

  final _issuesTypeSubject = PublishSubject<bool>();
  Stream<bool> get issueTypeStream => _issuesTypeSubject.stream;
  Sink<bool> get issueTypeSink => _issuesTypeSubject.sink;

  fetchAllIssues(bool isOpen) async {
	  try {
		  List<IssueItem> issuesList = await getIssuesUseCase.execute(isOpen);
		  print('Awaiting issue list...$issuesList');
		  allIssuesSink.add(issuesList);
	  } catch (error) {
		  print('Caught error: $error');
		  _issuesSubject.addError(error);
	  }
  }

  dispose() {
    _issuesSubject.close();
    _issuesTypeSubject.close();
  }
}

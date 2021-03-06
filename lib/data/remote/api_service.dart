import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ApiService {
  Future<List<IssueItem>> fetchIssues(bool isOpen) async {
  	String state = '${isOpen ? 'open': 'closed'}';
    Map<String, String> queryParams = {'state': state};
    var url = Uri.https('api.github.com', '/repos/flutter/flutter/issues', queryParams);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseIssues(response.body);
    } else {
	    print('Exception Occurred');
      throw Exception('Failed to load issues');
    }
  }

  List<IssueItem> parseIssues(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<IssueItem>((json) => IssueItem.fromJson(json)).toList();
  }
}

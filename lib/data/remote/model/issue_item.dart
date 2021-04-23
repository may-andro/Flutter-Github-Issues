class IssueItem {
	String url;
	int id;
	int number;
	String title;
	User user;
	String createdAt;
	String updatedAt;
	String closedAt;

	IssueItem({
		this.url,
		this.id,
		this.number,
		this.title,
		this.user,
		this.createdAt,
		this.updatedAt,
		this.closedAt,
	});

	IssueItem.fromJson(Map<String, dynamic> json) {
		url = json['url'];
		id = json['id'];
		number = json['number'];
		title = json['title'];
		user = json['user'] != null ? new User.fromJson(json['user']) : null;
		createdAt = json['created_at'];
		updatedAt = json['updated_at'];
		closedAt = json['closed_at'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['url'] = this.url;
		data['id'] = this.id;
		data['number'] = this.number;
		data['title'] = this.title;
		if (this.user != null) {
			data['user'] = this.user.toJson();
		}
		data['created_at'] = this.createdAt;
		data['updated_at'] = this.updatedAt;
		data['closed_at'] = this.closedAt;
		return data;
	}
}

class User {
	String login;
	String avatarUrl;

	User({this.login, this.avatarUrl});

	User.fromJson(Map<String, dynamic> json) {
		login = json['login'];
		avatarUrl = json['avatar_url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['login'] = this.login;
		data['avatar_url'] = this.avatarUrl;
		return data;
	}
}
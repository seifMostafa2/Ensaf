class RequestsOrderForLawyerEntity {
  List<RequestsOrderInfo>? data;

  RequestsOrderForLawyerEntity({this.data});
}

class RequestsOrderInfo {
  int? id;
  int? expectedDays;
  double? expectedBudget;
  String? info;
  List<String>? files;
  String? createdAt;
  RequesOrder? order;

  RequestsOrderInfo(
      {this.id,
      this.expectedDays,
      this.expectedBudget,
      this.info,
      this.files,
      this.createdAt,
      this.order});

  RequestsOrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expectedDays = json['expected_days'];
    expectedBudget = json['expected_budget'];
    info = json['info'];
    files = json['files'].cast<String>();
    createdAt = json['created_at'];
    order =
        json['order'] != null ? new RequesOrder.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expected_days'] = this.expectedDays;
    data['expected_budget'] = this.expectedBudget;
    data['info'] = this.info;
    data['files'] = this.files;
    data['created_at'] = this.createdAt;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class RequesOrder {
  int? id;
  String? title;
  String? description;
  int? requests;
  String? city;
  bool? canRequest;
  String? createdAt;

  RequesOrder(
      {this.id,
      this.title,
      this.description,
      this.requests,
      this.city,
      this.canRequest,
      this.createdAt});

  RequesOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    requests = json['requests'];
    city = json['city'];
    canRequest = json['can_request'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['requests'] = this.requests;
    data['city'] = this.city;
    data['can_request'] = this.canRequest;
    data['created_at'] = this.createdAt;
    return data;
  }
}

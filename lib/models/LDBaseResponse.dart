class LDBaseResponse {
  int? orderId;
  bool? status;
  String? message;
  String? url;
  Data? data;

  LDBaseResponse({this.status, this.message, this.url, this.data,this.orderId});

  LDBaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    url = json['url'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['url'] = this.url;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['order_id'] = this.orderId;
    return data;
  }
}

class Data {
  int? id;

  Data({this.id});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
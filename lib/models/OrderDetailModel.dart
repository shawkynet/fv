import '../models/OrderModel.dart';

import 'OrderHistoryModel.dart';

class OrderDetailModel {
  OrderModel? data;
  Payment? payment;
  List<OrderHistoryModel>? orderHistory;

  OrderDetailModel({this.data, this.orderHistory});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderModel.fromJson(json['data']) : null;
    payment = json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    if (json['order_history'] != null) {
      orderHistory = <OrderHistoryModel>[];
      json['order_history'].forEach((v) {
        orderHistory!.add(new OrderHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.orderHistory != null) {
      data['order_history'] = this.orderHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  int? id;
  int? orderId;
  int? clientId;
  String? clientName;
  String? datetime;
  num? totalAmount;
  String? paymentType;
  String? txnId;
  String? paymentStatus;
  var transactionDetail;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  num? cancelCharges;
  num? adminCommission;
  String? receivedBy;
  num? deliveryManFee;
  num? deliveryManTip;
  num? deliveryManCommission;

  Payment(
      {this.id,
        this.orderId,
        this.clientId,
        this.clientName,
        this.datetime,
        this.totalAmount,
        this.paymentType,
        this.txnId,
        this.paymentStatus,
        this.transactionDetail,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.cancelCharges,
        this.adminCommission,
        this.receivedBy,
        this.deliveryManFee,
        this.deliveryManTip,
        this.deliveryManCommission});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    clientId = json['client_id'];
    clientName = json['client_name'];
    datetime = json['datetime'];
    totalAmount = json['total_amount'];
    paymentType = json['payment_type'];
    txnId = json['txn_id'];
    paymentStatus = json['payment_status'];
    transactionDetail = json['transaction_detail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    cancelCharges = json['cancel_charges'];
    adminCommission = json['admin_commission'];
    receivedBy = json['received_by'];
    deliveryManFee = json['delivery_man_fee'];
    deliveryManTip = json['delivery_man_tip'];
    deliveryManCommission = json['delivery_man_commission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['client_id'] = this.clientId;
    data['client_name'] = this.clientName;
    data['datetime'] = this.datetime;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['txn_id'] = this.txnId;
    data['payment_status'] = this.paymentStatus;
    data['transaction_detail'] = this.transactionDetail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['cancel_charges'] = this.cancelCharges;
    data['admin_commission'] = this.adminCommission;
    data['received_by'] = this.receivedBy;
    data['delivery_man_fee'] = this.deliveryManFee;
    data['delivery_man_tip'] = this.deliveryManTip;
    data['delivery_man_commission'] = this.deliveryManCommission;
    return data;
  }
}

import 'dart:ffi';

class Subscription {
  String subscriptioncode;
  String subscriptionname;
  Double price;
  Double period;
  String type;
  String createdby;
  String periodunit;

  Subscription(
      {this.subscriptioncode = '0',
      this.subscriptionname = '',
      required this.price,
      required this.period,
      this.type = '',
      this.createdby = '',
      this.periodunit = ''});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscriptioncode: json['accountcode'],
      subscriptionname: json['accountname'],
      price: json['lastname'] ?? '',
      period: json['worktitle'],
      type: json['rolewithemployer'],
      createdby: json['phonenumber'],
      periodunit: json['workemail'],
    );
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map['subscriptioncode'] = subscriptioncode;
    map["subscriptionname"] = subscriptionname;
    map["price"] = price;
    map['period'] = period;
    map['type'] = type;
    map['createdby'] = createdby;
    map['periodunit'] = periodunit;

    return map;
  }
}



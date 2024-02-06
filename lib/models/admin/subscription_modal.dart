class Subscription {
  final int id;
  final String type;
  final String subscriptionname;
  final String priceunit;
  final double price;
  final String periodunit;
  final int period;
  final String subscriptioncode;

  Subscription({
    required this.id,
    required this.type,
    required this.subscriptionname,
    required this.priceunit,
    required this.price,
    required this.periodunit,
    required this.period,
    required this.subscriptioncode,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      subscriptionname: json['subscriptionname'] ?? '',
      priceunit: json['priceunit'] ?? '',
      price: json['price'] ?? 0.0,
      periodunit: json['periodunit'] ?? '',
      period: json['period'] ?? 0,
      subscriptioncode: json['subscriptioncode'] ?? '',
    );
  }
}

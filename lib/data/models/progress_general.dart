class ProgressGeneral {
  final String orderSale;
  final String workPlace;
  final String quoteNumber;
  final String rfq;
  final String especialty;

  const ProgressGeneral({
    required this.orderSale,
    required this.workPlace,
    required this.quoteNumber,
    required this.rfq,
    required this.especialty,
  });

  ProgressGeneral copyWith({
    String? orderSale,
    String? workPlace,
    String? quoteNumber,
    String? rfq,
    String? especialty,
  }) {
    return ProgressGeneral(
      orderSale: orderSale ?? this.orderSale,
      workPlace: workPlace ?? this.workPlace,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      rfq: rfq ?? this.rfq,
      especialty: especialty ?? this.especialty,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderSale': orderSale,
    'workPlace': workPlace,
    'quoteNumber': quoteNumber,
    'rfq': rfq,
    'especialty': especialty,
  };

  factory ProgressGeneral.fromJson(Map<String, dynamic> json) {
    return ProgressGeneral(
      orderSale: json['orderSale'] ?? '',
      workPlace: json['workPlace'] ?? '',
      quoteNumber: json['quoteNumber'] ?? '',
      rfq: json['rfq'] ?? '',
      especialty: json['especialty'] ?? '',
    );
  }
}

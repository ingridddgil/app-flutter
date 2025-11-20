class ProgressGeneral {
  final String orderSale;
  final String obra; 
  final String workPlace;
  final String quoteNumber;
  final String rfq;
  final String especialidad;

  const ProgressGeneral({
    required this.orderSale,
    required this.obra,
    required this.workPlace,
    required this.quoteNumber,
    required this.rfq,
    required this.especialidad,
  });

  ProgressGeneral copyWith({
  String? orderSale,
  String? obra,
  String? workPlace,
  String? quoteNumber,
  String? rfq,
  String? especialidad,
}) {
  return ProgressGeneral(
    orderSale: orderSale ?? this.orderSale,
    obra: obra ?? this.obra,
    workPlace: workPlace ?? this.workPlace,
    quoteNumber: quoteNumber ?? this.quoteNumber,
    rfq: rfq ?? this.rfq,
    especialidad: especialidad ?? this.especialidad,
  );
}

}

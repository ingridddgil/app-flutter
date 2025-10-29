import 'dart:math';

final random = Random();
final List<String> projectTitles =
    List.generate(6, (i) => '${random.nextInt(10000)}');


final List<String> clients = [
  'INNOPHOS FOSFATADOS DE MÉXICO', 
  'GEOSTOCK OPERACIÓN S.A DE C.V', 
  'PETROQUIMICA MEXICANA DE VINILO S.A DE C.V', 
  'PRO-AGROINDUSTRIA', 
  'TEREFTALATOS MEXICANOS'
];

final List<String> supervisors = [
  'Juan Pérez', 
  'María López', 
  'Carlos Sánchez', 
  'Ana Gómez', 
  'Luis Rodríguez'
];
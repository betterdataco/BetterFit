import 'package:equatable/equatable.dart';

class FoodSearchResult extends Equatable {
  final String fdcId;
  final String description;
  final String? brandName;
  final String? brandOwner;
  final List<FoodNutrient> nutrients;
  final String? dataType;
  final String? publicationDate;

  const FoodSearchResult({
    required this.fdcId,
    required this.description,
    this.brandName,
    this.brandOwner,
    this.nutrients = const [],
    this.dataType,
    this.publicationDate,
  });

  factory FoodSearchResult.fromJson(Map<String, dynamic> json) {
    return FoodSearchResult(
      fdcId: json['fdcId'].toString(),
      description: json['description'] ?? '',
      brandName: json['brandName'],
      brandOwner: json['brandOwner'],
      nutrients: json['foodNutrients'] != null
          ? (json['foodNutrients'] as List)
              .map((n) => FoodNutrient.fromJson(n))
              .toList()
          : [],
      dataType: json['dataType'],
      publicationDate: json['publicationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fdcId': fdcId,
      'description': description,
      'brandName': brandName,
      'brandOwner': brandOwner,
      'foodNutrients': nutrients.map((n) => n.toJson()).toList(),
      'dataType': dataType,
      'publicationDate': publicationDate,
    };
  }

  @override
  List<Object?> get props => [
        fdcId,
        description,
        brandName,
        brandOwner,
        nutrients,
        dataType,
        publicationDate,
      ];
}

class FoodNutrient extends Equatable {
  final int nutrientId;
  final String nutrientName;
  final String unitName;
  final double value;
  final String? derivationCode;
  final String? derivationDescription;

  const FoodNutrient({
    required this.nutrientId,
    required this.nutrientName,
    required this.unitName,
    required this.value,
    this.derivationCode,
    this.derivationDescription,
  });

  factory FoodNutrient.fromJson(Map<String, dynamic> json) {
    // Handle nested nutrient structure from FDA API
    final nutrient = json['nutrient'] as Map<String, dynamic>?;
    final amount = json['amount'] as double?;

    return FoodNutrient(
      nutrientId: nutrient?['id'] ?? json['nutrientId'] ?? 0,
      nutrientName: nutrient?['name'] ?? json['nutrientName'] ?? '',
      unitName: nutrient?['unitName'] ?? json['unitName'] ?? '',
      value: amount ?? (json['value'] ?? 0.0).toDouble(),
      derivationCode: json['derivationCode'],
      derivationDescription: json['derivationDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nutrientId': nutrientId,
      'nutrientName': nutrientName,
      'unitName': unitName,
      'value': value,
      'derivationCode': derivationCode,
      'derivationDescription': derivationDescription,
    };
  }

  @override
  List<Object?> get props => [
        nutrientId,
        nutrientName,
        unitName,
        value,
        derivationCode,
        derivationDescription,
      ];
}

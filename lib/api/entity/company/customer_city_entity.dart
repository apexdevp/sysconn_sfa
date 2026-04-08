class CustomerCityEntity {
  final String id;
  final String name;
  final String stateId;

  CustomerCityEntity({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory CustomerCityEntity.fromJson(Map<String, dynamic> json) {
    return CustomerCityEntity(
      id: (json['cityid'] ?? '').toString(),
      name: json['cityname'] ?? '',
      stateId: (json['stateid'] ?? '').toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerCityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class AreaEntity {
  final String id;
  final String name;
  final String cityId;

  AreaEntity({required this.id, required this.name, required this.cityId});

  factory AreaEntity.fromJson(Map<String, dynamic> json) {
    return AreaEntity(
      id: (json['cityareaid'] ?? '').toString(),
      name: json['cityareaname'] ?? '',
      cityId: (json['cityid'] ?? '').toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class LocalityEntity {
  final String id;
  final String name;
  final String areaId;

  LocalityEntity({required this.id, required this.name, required this.areaId});

  factory LocalityEntity.fromJson(Map<String, dynamic> json) {
    return LocalityEntity(
      id: (json['localityid'] ?? '').toString(),
      name: json['localityname'] ?? '',
      areaId: (json['cityareaid'] ?? '').toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CountryEntity {
  final String id;
  final String name;
  final String shortname;
  final String currency;

  CountryEntity({
    required this.id,
    required this.name,
    required this.shortname,
    required this.currency,
  });

  factory CountryEntity.fromJson(Map<String, dynamic> json) {
    return CountryEntity(
      id: (json['countryid'] ?? '').toString(),
      name: json['name'] ?? '',
      shortname: json['shortname'] ?? '',
      currency: json['currency'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class StateEntity {
  final String id;
  final String name;
  final String countryId;
  final String shortname;
  final String region;

  StateEntity({
    required this.id,
    required this.name,
    required this.countryId,
    required this.shortname,
    required this.region,
  });

  factory StateEntity.fromJson(Map<String, dynamic> json) {
    return StateEntity(
      id: (json['stateid'] ?? '').toString(),
      name: json['name'] ?? '',
      countryId: (json['countryid'] ?? '').toString(),
      shortname: json['shortname'] ?? '',
      region: json['region'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

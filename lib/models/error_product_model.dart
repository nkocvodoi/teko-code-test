class ErrorProduct {
  final int id;
  final String errorDescription;
  String? name;
  String? sku;
  final String image;
  int? color;

  ErrorProduct({
    required this.id,
    required this.errorDescription,
    required this.image,
    this.name,
    this.sku,
    this.color,
  });

  static ErrorProduct fromJson(dynamic json) {
    return ErrorProduct(
        name: json['name'].toString(),
        id: json['id'],
        sku: json['sku'],
        errorDescription: json['errorDescription'].toString(),
        image: json['image'].toString(),
        color: json['color']);
  }
}

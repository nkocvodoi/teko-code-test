class ErrorProduct {
  final int id;
  final String errorDescription;
  late String name;
  late String sku;
  final String image;
  late int color;

  ErrorProduct(
    {required this.id,
      required this.errorDescription,
      required this.image,
      this.name = '',
      this.sku = '',
      this.color = 0,
    });

  static ErrorProduct fromJson(dynamic json) {
    return ErrorProduct(
        name: json['name'].toString(),
        id: json['id'].toInt(),
        sku: json['sku'].toString(),
        errorDescription: json['errorDescription'].toString(),
        image: json['image'].toString(),
        color: json['color'].toInt());
  }
}
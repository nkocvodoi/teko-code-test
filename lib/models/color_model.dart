class ColorModel {
  final String name;
  final int id;
  const ColorModel({required this.id, required this.name});

  static ColorModel fromJson(dynamic json) {
    return ColorModel(
        name: json['name'].toString(),
        id: json['id'].toInt());
  }
}

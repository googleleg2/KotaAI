class Ingredient {
  final String id;

  /// Display name.
  final String name;

  /// Price added to the Kota.
  final double price;

  /// Asset path.
  final String imagePath;

  /// Optional legacy design width.
  ///
  /// The responsive renderer should calculate the actual width
  /// from the available Kota size.
  final double width;

  /// Optional legacy stack height.
  ///
  /// The responsive renderer should calculate the actual vertical
  /// spacing from the available Kota size.
  final double stackHeight;

  /// Whether customers can currently order it.
  final bool available;

  /// Optional description.
  final String description;

  const Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.width = 170,
    this.stackHeight = 18,
    this.available = true,
    this.description = '',
  });

  factory Ingredient.fromMap(
    Map<String, dynamic> map,
  ) {
    return Ingredient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imagePath: map['imagePath'] ?? '',

      // Kept only for compatibility with existing Firestore data.
      width: (map['width'] ?? 170).toDouble(),
      stackHeight:
          (map['stackHeight'] ?? 18).toDouble(),

      available: map['available'] ?? true,
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'width': width,
      'stackHeight': stackHeight,
      'available': available,
      'description': description,
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    double? price,
    String? imagePath,
    double? width,
    double? stackHeight,
    bool? available,
    String? description,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      width: width ?? this.width,
      stackHeight: stackHeight ?? this.stackHeight,
      available: available ?? this.available,
      description: description ?? this.description,
    );
  }
}


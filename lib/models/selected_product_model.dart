class SelectedProductData {
  String pId;
  String nombre;
  double precio;
  double promo;
  String imagen;
  double total;
  int cantidad;

  SelectedProductData({
    required this.pId,
    required this.nombre,
    required this.precio,
    required this.promo,
    required this.imagen,
    required this.total,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'nombre': nombre,
      'precio': precio,
      'promo': promo,
      'imagen': imagen,
      'total': total,
      'cantidad': cantidad,
    };
  }

  factory SelectedProductData.fromMap(Map<String, dynamic> map) {
    return SelectedProductData(
      pId: map['pId'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] as num?)?.toDouble() ?? 0.0,
      promo: (map['promo'] as num?)?.toDouble() ?? 0.0,
      imagen: map['imagen'] ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      cantidad: map['cantidad'] ?? 0,
    );
  }
}

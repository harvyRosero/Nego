class ProductData {
  String pId;
  String nombre;
  String nombreEmpresa;
  String descripcion;
  double precio;
  String imagen;
  bool principal;
  String categoria;
  int stock;
  double rating;

  ProductData({
    required this.pId,
    required this.nombre,
    required this.nombreEmpresa,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.principal,
    required this.categoria,
    this.stock = 0,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'nombre': nombre,
      'nombreEmpresa': nombreEmpresa,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'principal': principal,
      'categoria': categoria,
      'stock': stock,
      'rating': rating,
    };
  }

  factory ProductData.fromMap(Map<String, dynamic> map) {
    return ProductData(
      pId: map['pId'],
      nombre: map['nombre'],
      nombreEmpresa: map['nombreEmpresa'],
      descripcion: map['descripcion'],
      precio: map['precio'].toDouble(),
      imagen: map['imagen'],
      principal: map['principal'],
      categoria: map['categoria'],
      stock: map['stock'] ?? 0,
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }
}

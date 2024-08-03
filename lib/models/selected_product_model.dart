class SelectedProductData {
  String pId;
  String nombre;
  String nombreEmpresa;
  String descripcion;
  double precio;
  String imagen;
  double total;
  int cantidad;

  SelectedProductData({
    required this.pId,
    required this.nombre,
    required this.nombreEmpresa,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.total,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'nombre': nombre,
      'nombreEmpresa': nombreEmpresa,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'total': total,
      'cantidad': cantidad,
    };
  }

  factory SelectedProductData.fromMap(Map<String, dynamic> map) {
    return SelectedProductData(
      pId: map['pId'],
      nombre: map['nombre'],
      nombreEmpresa: map['nombreEmpresa'],
      descripcion: map['descripcion'],
      precio: map['precio'].toDouble(),
      imagen: map['imagen'],
      total: map['total'],
      cantidad: map['cantidad'],
    );
  }
}

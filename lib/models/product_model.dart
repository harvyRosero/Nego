class ProductData {
  String nombre;
  String nombreEmpresa;
  String descripcion;
  String precio;
  String imagen;
  String uid;
  bool principal;
  String categoria;

  ProductData(
      {required this.nombre,
      required this.nombreEmpresa,
      required this.descripcion,
      required this.precio,
      required this.imagen,
      required this.uid,
      required this.principal,
      required this.categoria});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'nombreEmpresa': nombreEmpresa,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'uid': uid,
      'principal': principal,
      'categoria': categoria,
    };
  }
}

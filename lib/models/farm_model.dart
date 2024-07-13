class FarmData {
  String categoria;
  String nombre;
  String descripcion;
  String departamento;
  String ubicacion;
  String lugarCercano;
  String producto;
  String estado;
  String contacto;
  String userId;
  String imagePerfil;
  String imagePortada;
  String fechaCreacion;

  FarmData({
    required this.categoria,
    required this.nombre,
    required this.descripcion,
    required this.departamento,
    required this.ubicacion,
    required this.lugarCercano,
    required this.producto,
    required this.estado,
    required this.contacto,
    required this.userId,
    required this.imagePerfil,
    required this.imagePortada,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'departamento': departamento,
      'ubicacion': ubicacion,
      'lugarCercano': lugarCercano,
      'producto': producto,
      'estado': estado,
      'contacto': contacto,
      'userId': userId,
      'imagePerfil': imagePerfil,
      'imagePortada': imagePortada,
      'fechaCreacion': fechaCreacion,
    };
  }
}

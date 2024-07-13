class StoreData {
  String categoria;
  String tienda;
  String descripcion;
  String ubicacion;
  String departamento;
  String contacto;
  String image;
  String imagePortada;
  String userId;
  String fechaCreacion;

  StoreData({
    required this.categoria,
    required this.descripcion,
    required this.tienda,
    required this.ubicacion,
    required this.departamento,
    required this.contacto,
    required this.image,
    required this.imagePortada,
    required this.userId,
    required this.fechaCreacion,
  });

  // Método para convertir los datos a un mapa (para enviar a Firebase)
  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'tienda': tienda,
      'descripcion': descripcion,
      'contacto': contacto,
      'ubicacion': ubicacion,
      'departamento': departamento,
      'image': image,
      'imagePortada': imagePortada,
      'userId': userId,
      'fechaCreacion': fechaCreacion,
    };
  }
}

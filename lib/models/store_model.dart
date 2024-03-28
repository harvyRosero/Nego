class StoreData {
  String categoria;
  String tienda;
  String descripcion;
  String ubicacion;
  String contacto;
  String image;
  String imagePortada;
  String userId;

  StoreData({
    required this.categoria,
    required this.descripcion,
    required this.tienda,
    required this.ubicacion,
    required this.contacto,
    required this.image,
    required this.imagePortada,
    required this.userId,
  });

  // Método para convertir los datos a un mapa (para enviar a Firebase)
  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'tienda': tienda,
      'descripcion': descripcion,
      'contacto': contacto,
      'ubicacion': ubicacion,
      'image': image,
      'imagePortada': imagePortada,
      'userId': userId,
    };
  }
}

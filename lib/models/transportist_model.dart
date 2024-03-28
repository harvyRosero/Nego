class TransportistData {
  String categoria;
  String nombre;
  String descripcion;
  String camion;
  String ubicacion;
  String capacidadCarga;
  String contacto;
  String userId;
  String image;
  String imagePortada;

  TransportistData({
    required this.categoria,
    required this.nombre,
    required this.descripcion,
    required this.camion,
    required this.ubicacion,
    required this.capacidadCarga,
    required this.contacto,
    required this.userId,
    required this.image,
    required this.imagePortada,
  });

  // Método para convertir los datos a un mapa (para enviar a Firebase)
  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'camion': camion,
      'ubicacion': ubicacion,
      'capacidadCarga': capacidadCarga,
      'contacto': contacto,
      'userId': userId,
      'image': image,
      'imagePortada': imagePortada,
    };
  }
}

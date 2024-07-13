class TransportistData {
  String categoria;
  String nombre;
  String descripcion;
  String camion;
  String ubicacion;
  String departamento;
  String capacidadCarga;
  String tipoCarga;
  String contacto;
  String userId;
  String image;
  String fechaCreacion;
  String imagePortada;

  TransportistData({
    required this.categoria,
    required this.nombre,
    required this.descripcion,
    required this.camion,
    required this.ubicacion,
    required this.departamento,
    required this.capacidadCarga,
    required this.tipoCarga,
    required this.contacto,
    required this.userId,
    required this.image,
    required this.imagePortada,
    required this.fechaCreacion,
  });

  // Método para convertir los datos a un mapa (para enviar a Firebase)
  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'camion': camion,
      'ubicacion': ubicacion,
      'departamento': departamento,
      'capacidadCarga': capacidadCarga,
      'tipoCarga': tipoCarga,
      'contacto': contacto,
      'userId': userId,
      'image': image,
      'imagePortada': imagePortada,
      'fechaCreacion': fechaCreacion,
    };
  }
}

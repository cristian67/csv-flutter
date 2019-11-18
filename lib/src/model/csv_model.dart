

class CsvModel {
    int id;
    String nombre;
    int edad;

    CsvModel({
        this.id,
        this.nombre,
        this.edad,
    });

    factory CsvModel.fromJson(Map<String, dynamic> json) => CsvModel(
        id: json["id"],
        nombre: json["nombre"],
        edad: json["edad"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "edad": edad,
    };
}
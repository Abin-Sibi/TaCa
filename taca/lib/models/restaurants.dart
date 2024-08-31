class Restaurant {
  final String id;
  final String name;
  final String place;
  final String mobno;
  final String emailid;
  final String type;
  final String category;
  final String geography;
  final List<TableModel> tables;
  final String imageUrl;
  final int rating;
  final double averageRating;
  

  Restaurant({
    required this.id,
    required this.name,
    required this.place,
    required this.mobno,
    required this.emailid,
    required this.type,
    required this.category,
    required this.geography,
    required this.tables,
    required this.imageUrl, 
    required this.rating,
    required this.averageRating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] is Map ? json['_id']['\$oid'] : json['_id'],
      name: json['name'],
      place: json['place'],
      mobno: json['mobno'],
      emailid: json['emailid'],
      type: json['type'],
      category: json['category'],
      geography: json['geography'],
      tables: (json['tables'] as List).map((i) => TableModel.fromJson(i)).toList(),
      imageUrl: json['imageUrl'] ?? 'assets/images/splash_logo.png',
      rating: json['rating'] ?? 5,
       averageRating: json['averageRating']?.toDouble() ?? 0.0,
    );
  }
}

class TableModel {
  final int tableNumber;
  final int chairs;
  final int x;
  final int y;

  TableModel({
    required this.tableNumber,
    required this.chairs,
    required this.x,
    required this.y,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      tableNumber: json['tableNumber'],
      chairs: json['chairs'],
      x: (json['position']?['x'] ?? 0 as num).toInt(), // Safely access and provide default values
      y: (json['position']?['y'] ?? 0 as num).toInt(),
    );
  }
}

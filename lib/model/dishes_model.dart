class Dishes{
  String dishName;
  String dishId;
  String imageUrl;

//<editor-fold desc="Data Methods">
  Dishes({
    required this.dishName,
    required this.dishId,
    required this.imageUrl,
  });


  Dishes copyWith({
    String? dishName,
    String? dishId,
    String? imageUrl,
  }) {
    return Dishes(
      dishName: dishName ?? this.dishName,
      dishId: dishId ?? this.dishId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dishName': this.dishName,
      'dishId': this.dishId,
      'imageUrl': this.imageUrl,
    };
  }

  factory Dishes.fromMap(Map<String, dynamic> map) {
    return Dishes(
      dishName: map['dishName']??"",
      dishId: map['dishId'] ??"",
      imageUrl: map['imageUrl']??"",
    );
  }

//</editor-fold>
}
class MyFollowers {

    final String name, image;

  MyFollowers({required this.name,required this.image});

    Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "image": this.image,
    };
  }

  factory MyFollowers.fromJson(Map<String, dynamic> json) {
    return MyFollowers(
      name: json["name"],
      image: json["image"],
    );
  }
//
}

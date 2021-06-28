class PersonModel {
  String name;
  String imgURL;
  int age;
  List<dynamic> interests = [];

  PersonModel({
    this.name,
    this.imgURL,
    this.interests,
    this.age,
  });

  PersonModel.fromJSON(Map<String, dynamic> jsonData) {
    this.name = jsonData['name'];
    this.imgURL = jsonData['image_url'];
    this.age = jsonData['age'];
    this.interests = jsonData['interests'];
  }
}

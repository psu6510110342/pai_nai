class PopularModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  PopularModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<PopularModel> populars = popularsData
    .map((item) => PopularModel(item['name'], item['tagLine'], item['image'],
        item['images'], item['description'], item['price']))
    .toList();

var popularsData = [
  {
    "name": "Alive ชีวิต ชีวา restaurant",
    "tagLine": "Natural restaurant",
    "image":
        "https://images.unsplash.com/photo-1639389764072-366c18f6bd37?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639389764086-c84584256374?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    ],
    "description":
        "Alive ชีวิต ชีวา restaurant is natural restaurant and delicious foods",
    "price": 130
  },
  {
    "name": "Asian night bazaar market",
    "tagLine": "Night market",
    "image":
        "https://images.unsplash.com/photo-1639648530008-3af34181ab83?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639648527151-bff3f3508e9e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    ],
    "description":
        "Asian night bazaar market is street markets which operate at night and is generally dedicated to more leisurely strolling, shopping, and eating than more businesslike day markets. ",
    "price": 120
  },
];

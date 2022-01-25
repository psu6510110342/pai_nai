class TampleModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  TampleModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<TampleModel> tamples = tamplesData
    .map((item) => TampleModel(item['name'], item['tagLine'], item['image'],
        item['images'], item['description'], item['price']))
    .toList();

var tamplesData = [
  {
    "name": "Phra Phutthamongkol Maharat",
    "tagLine": "standing golden buddha",
    "image":
        "https://images.unsplash.com/photo-1637575729353-fcbee495425e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MzV8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "images": [
      "https://images.unsplash.com/photo-1637575721475-2f83e74dd834?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MzZ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
      "https://images.unsplash.com/photo-1637575415239-124bf2e96e7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    ],
    "description":
        "Raja Ampat is one of the favorite tourist destination, you can feel cultural tourism and history to explore exotic beaches in Raja Ampat",
    "price": 130
  },
  {
    "name": "Stainless steel Buddhist temple ",
    "tagLine": "Buddhist temple ",
    "image":
        "https://images.unsplash.com/photo-1639216144928-2707b1e0abd9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639216144928-2707b1e0abd9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
    ],
    "description":
        "Stainless steel Buddhist temple is contemporary Buddhist place of worship with a conical shape made of open-work metal. ",
    "price": 120
  },
];

class CafeModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  CafeModel(this.name, this.tagLine, this.image, this.images, this.description,
      this.price);
}

List<CafeModel> cafes = cafesData
    .map((item) => CafeModel(item['name'], item['tagLine'], item['image'],
        item['images'], item['description'], item['price']))
    .toList();

var cafesData = [
  {
    "name": "The Tern cafe",
    "tagLine": "Modern cafe",
    "image":
        "https://images.unsplash.com/photo-1639219170747-75719f662e55?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=302&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639219171401-3e3c21505813?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    ],
    "description": "The Tern cafe is one of the favorite local perple place",
    "price": 130
  },
  {
    "name": "Avenue cafe ",
    "tagLine": "Vibe cafe",
    "image":
        "https://images.unsplash.com/photo-1639389763475-80dbe77050e0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639219170906-854ba3a8ad33?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
    ],
    "description": "Great coffee with relaxing decoration.",
    "price": 120
  },
  {
    "name": "la pause hatyai",
    "tagLine": "Comfortabel cafe",
    "image":
        "https://images.unsplash.com/photo-1639563974423-42a23bda79a5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTR8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "images": [
      "https://images.unsplash.com/photo-1639563974930-d707c0da8fb9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ],
    "description":
        "They have an extremely helpful team that goes all out to take care of your needs ",
    "price": 110
  },
];

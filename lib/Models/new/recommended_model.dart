class RecommendedModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  RecommendedModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<RecommendedModel> recommendations = recommendationsData
    .map((item) => RecommendedModel(item['name'], item['tagLine'],
        item['image'], item['images'], item['description'], item['price']))
    .toList();

var recommendationsData = [
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
        "Phra Phutthamongkol Maharat is one of the favorite tourist destination, you can feel cultural tourism and history to explore",
    "price": 130
  },
  {
    "name": "Greenway Night Market",
    "tagLine": "Night Market place",
    "image":
        "https://images.unsplash.com/photo-1639390696407-78419da8ad47?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639390697033-de0d91927a97?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1158&q=80",
    ],
    "description":
        "Greenway Night Market is the most famous night market place that you shoud not miss it !!!!",
    "price": 120
  },
  {
    "name": "Central festival hatyai",
    "tagLine": "department store",
    "image":
        "https://images.unsplash.com/photo-1639648526411-1fb6ad6d7be6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1022&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639648526411-1fb6ad6d7be6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1022&q=80",
    ],
    "description":
        "CentralFestival Hatyai is a brand-new shopping experience, offering a fantastic range of fun and entertainment options that will ensure all our visitors of happiness and unforgettable memories of Hat Yai and its people.",
    "price": 110
  },
];

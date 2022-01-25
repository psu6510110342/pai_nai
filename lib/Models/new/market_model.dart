class MarketModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  MarketModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<MarketModel> markets = marketsData
    .map((item) => MarketModel(item['name'], item['tagLine'], item['image'],
        item['images'], item['description'], item['price']))
    .toList();

var marketsData = [
  {
    "name": "Kim Yong Market",
    "tagLine": "Local Market",
    "image":
        "https://images.unsplash.com/photo-1639390694135-fbff38503a38?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639390694127-a6cea6f4b05d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MjJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ],
    "description":
        "Kim Yong Market good place for buying snacks, souvenirs and clothes in Hat Yai. Not too far from the train station",
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
  }
];

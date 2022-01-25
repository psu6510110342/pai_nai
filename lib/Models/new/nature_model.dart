class NatureModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  NatureModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<NatureModel> natures = naturesData
    .map((item) => NatureModel(item['name'], item['tagLine'], item['image'],
        item['images'], item['description'], item['price']))
    .toList();

var naturesData = [
  {
    "name": "Krua Reuan Thai",
    "tagLine": "Luxury restaurant",
    "image":
        "https://images.unsplash.com/photo-1639479111398-6968583e7b5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTV8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "images": [
      "https://images.unsplash.com/photo-1639479109483-8fd402fcd0e9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTZ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ],
    "description":
        "Food are extremely yummy, and the souvenir shop is selling yummy biscuit & pastry.",
    "price": 130
  },
  {
    "name": "Nai Roo restaurant",
    "tagLine": "Local restaurant",
    "image":
        "https://images.unsplash.com/photo-1639479105604-3b5c66074f77?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTl8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    "images": [
      "hhttps://images.unsplash.com/photo-1639479108546-448b41188913?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwcm9maWxlLXBhZ2V8MTd8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ],
    "description":
        "Located in small alley, but worth to visit. Tasty Chinese seafood and traditional southern Thai food.",
    "price": 120
  },
];

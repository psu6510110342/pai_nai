class NewdestinationModel {
  String name;
  String tagLine;
  String image;
  List<String> images;
  String description;
  int price;

  NewdestinationModel(this.name, this.tagLine, this.image, this.images,
      this.description, this.price);
}

List<NewdestinationModel> newdestinations = newdestinationsData
    .map((item) => NewdestinationModel(item['name'], item['tagLine'],
        item['image'], item['images'], item['description'], item['price']))
    .toList();

var newdestinationsData = [
  {
    "name": "Makinta Night Market Hatyai",
    "tagLine": " Night Market Hatyai",
    "image":
        "https://images.unsplash.com/photo-1639390694563-56b634aa902b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639390694654-a5cc68334589?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
      "https://images.unsplash.com/photo-1639390694702-df7b3e6d622f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80",
    ],
    "description":
        "Makinta Night Market Hatyai is a new destination place where you can buy many street foods",
    "price": 130
  },
  {
    "name": "PSU Reservoir Park",
    "tagLine": "Natural Park",
    "image":
        "https://images.unsplash.com/photo-1639648530112-1d4f878f1cbf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    "images": [
      "https://images.unsplash.com/photo-1639648529711-86aff4d71bed?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    ],
    "description": "PSU Reservoir Park is a beautiful park",
    "price": 120
  },
];

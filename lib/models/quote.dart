class Quote {
  String id;
  String quote;
  String character;
  String image;
  String author;
  String authorId;

  Quote({
    this.quote,
    this.character,
    this.image,
    this.author,
    this.authorId,
  });

  Quote.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.quote = json['quote'];
    this.character = json['character'];
    this.image = json['image'];
    this.author = json['author'];
    this.authorId = json['authorId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'quote': this.quote,
      'character': this.character,
      'image': this.image,
      'author': this.author,
      'authorId': this.authorId,
    };
  }
}

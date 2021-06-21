class Repo {
  final String owner;
  final String name;

  Repo(this.name, this.owner);

  Repo.fromJson(Map<String, dynamic> json)
      : owner = json['owner'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'owner': owner,
    'name': name,
  };

}
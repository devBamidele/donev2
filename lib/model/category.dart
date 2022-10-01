/// The structure of a [Category]
class Category {
  String group; // The group to which a T0DO belongs to

  int count; // The number of tasks in a given group

  Category({
    required this.group,
    required this.count,
  });
}

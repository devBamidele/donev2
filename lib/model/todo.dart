/// The structure of T0do Object
class Todo {
  int? id; //This is the primary key

  String task; // For example, "Buy milk"

  bool isDone; // This is the checkbox state

  String? category; // This is the category of the task

  String? completion; // This is when the task is to be completed

  String? alarm; // This is the alarm the user has set

  bool ring; // This shows if the alarm is toggled on or off

  bool recent; // This shows if the task has been recently searched for

  int? lastSearched; // This shows the last time the item was searched for

  /// The structure for an entry on the database
  Todo({
    this.id,
    required this.task,
    this.isDone = false,
    this.category,
    this.completion,
    this.alarm,
    this.ring = false,
    this.recent = false,
    this.lastSearched,
  });

  /// Convert Json objects to [Tod0] objects
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        id: data['id'],
        task: data['task'],
        isDone: data['is_done'] == 0
            ? false
            : true, //Since sqlite doesn't have boolean type for true/false
        category: data['category'],
        completion: data['completion'],
        alarm: data['alarm'],
        ring: data['ring'] == 0 ? false : true,
        recent: data['recent'] == 0 ? false : true,
        lastSearched: data['lastSearched'],
      );

  /// Convert T0do objects to Json objects to be stored in the database
  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "task": task,
        "is_done": isDone == false ? 0 : 1,
        "category": category,
        "completion": completion,
        "alarm": alarm,
        "ring": ring == false ? 0 : 1,
        "recent": recent == false ? 0 : 1,
        "lastSearched": lastSearched,
      };
}

class Todo {
  int? id; //This is the primary key

  String? task; // For example, "Buy milk"

  bool isDone = false; // This is the checkbox state

  String? category; // This is the category of the task

  String? completion; // This is when the task is to be completed

  Todo({
    this.id,
    this.task,
    this.isDone = false,
    this.category,
    this.completion,
  });

  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        // Convert Json objects to T0do objects
        id: data['id'],
        task: data['task'],
        isDone: data['is_done'] == 0
            ? false
            : true, //Since sqlite doesn't have boolean type for true/false
        category: data['category'],
        completion: data['completion'],
      );
  Map<String, dynamic> toDatabaseJson() => {
        // Convert T0do objects to Json objects to be stored in the database
        "id": id,
        "task": task,
        "is_done": isDone == false ? 0 : 1,
        "category": category,
        "completion": completion,
      };
}

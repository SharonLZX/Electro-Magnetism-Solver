class Result{
  final int id;
    final String question;
    final String result; //SQLITE doesn't have List, so we will format them as a single string

    const Result({
      required this.id,
        required this.question,
        required this.result,
    });

    Map<String, Object?> toMap(){
      return {
        'id': id,
        'question': question,
        'result': result,
      };
    }

    @override
    String toString(){
      return 'Result{id: $id, question: $question, result: $result}';
    }
}
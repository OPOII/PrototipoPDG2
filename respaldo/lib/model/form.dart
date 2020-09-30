class FeedbackForm {
  String name;
  String email;
  String mobileNo;
  String feedback;

  FeedbackForm(
    this.name,
    this.email,
    this.mobileNo,
    this.feedback,
    String text,
  );

  // Method to make GET parameters.
  Map toJson() => {
        'name': name,
        'email': email,
        'mobileNo': mobileNo,
        'feedback': feedback
      };
}

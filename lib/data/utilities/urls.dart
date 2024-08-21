class Urls {
  static const String _baseUrl = "https://task.teamrabbil.com/api/v1";

  static const String registration = "$_baseUrl/registration";
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTasks = '$_baseUrl/listTaskByStatus/New';
  static const String progressTask = '$_baseUrl/listTaskByStatus/Progress';
  static const String canceledTask = '$_baseUrl/listTaskByStatus/Canceled';
  static const String completedTasks = '$_baseUrl/listTaskByStatus/Completed';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String resetPassword = '$_baseUrl/RecoverResetPass';

  static String emailVerify(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';
  static String otpVerify(String email, String otp) =>
      '$_baseUrl/RecoverVerifyEmail/$email/$otp';


  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';

  static String updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';
  static String updateProfile = '$_baseUrl/profileUpdate';
}

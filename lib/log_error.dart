/// Represents the result of a logging operation, including error status and details.
///
/// A [LogError] instance encapsulates an error code, an optional message, and optional
/// additional data to describe the outcome of a logging-related action. It provides
/// utilities to check success or failure and to merge multiple errors.
///
/// Example:
/// ```dart
/// var error = LogError(0, message: "Success");
/// print(error.isSuccess); // true
/// ```
class LogError {
  /// Creates a new [LogError] instance.
  ///
  /// - [error]: The error code (positive or zero for success, negative for failure).
  /// - [message]: An optional description of the error (defaults to an empty string).
  /// - [data]: Optional additional data related to the error.
  LogError(this.error, {this.message = '', this.data});

  /// The error code indicating the result of the operation.
  ///
  /// A value of 0 or greater indicates success, while a negative value indicates failure.
  int error;

  /// A human-readable description of the error.
  String message;

  /// Additional data associated with the error, if any.
  dynamic data;

  /// Indicates whether the operation was successful.
  ///
  /// Returns `true` if [error] is greater than or equal to 0, `false` otherwise.
  bool get isSuccess => error >= 0;

  /// Indicates whether the operation failed.
  ///
  /// Returns `true` if [error] is less than 0, `false` otherwise.
  bool get isFail => error < 0;

  /// Returns a string representation of the error.
  ///
  /// If [message] is non-empty, includes both the [error] code and [message].
  /// Otherwise, returns only the [error] code as a string.
  @override
  String toString() {
    if (message.isNotEmpty) {
      return 'error:$error --> ($message)';
    }
    return '$error';
  }

  /// Merges this error with another [LogError], prioritizing the most severe error.
  ///
  /// - [newErr]: The new error to merge with this one.
  ///
  /// If [newErr] indicates success, no changes are made. Otherwise, the lowest (most
  /// negative) [error] code is retained, and the [message] is appended with the new
  /// message, separated by a slash.
  void mergeError(LogError newErr) {
    if (newErr.isSuccess) {
      return;
    }
    error = (error < newErr.error) ? error : newErr.error;
    message = '$message / ${newErr.message}';
  }
}

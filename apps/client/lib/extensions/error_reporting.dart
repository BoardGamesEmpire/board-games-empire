import '../data/api/api_exception.dart';
import '../blocs/error/error_bloc.dart';

extension ErrorReporting on Exception {
  void report(ErrorBloc errorBloc, {bool showDialog = false}) {
    if (this is ApiException) {
      (this as ApiException).report(errorBloc, showDialog: showDialog);
    } else {
      errorBloc.add(ErrorReported(toString(), shouldShowDialog: showDialog));
    }
  }
}

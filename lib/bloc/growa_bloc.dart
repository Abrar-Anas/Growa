import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'growa_event.dart';
part 'growa_state.dart';

class GrowaBloc extends Bloc<GrowaEvent, GrowaState> {
  GrowaBloc() : super(GrowaInitial()) {
    on<GrowaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

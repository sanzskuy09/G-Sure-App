import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormStateData> {
  FormBloc() : super(const FormStateData()) {
    // Daftarkan handler untuk event UpdateFormValue
    on<UpdateFormValue>(_onUpdateFormValue);
    // on<LoadForm>(_onLoadForm);
  }

  void _onUpdateFormValue(UpdateFormValue event, Emitter<FormStateData> emit) {
    // Buat salinan dari map yang ada
    final newAnswers = Map<String, dynamic>.from(state.formAnswers);
    // Update nilainya
    newAnswers[event.key] = event.value;
    // Emit state baru dengan map yang sudah diupdate
    emit(state.copyWith(formAnswers: newAnswers));
  }

  // Event handler untuk memuat data form dari JSON
  // Future<void> _onLoadForm(LoadForm event, Emitter<FormStateData> emit) async {
  //   emit(state.copyWith(status: FormStatus.loading));
  //   try {
  //     final String jsonStr = await rootBundle.loadString('assets/question_data1.json');
  //     final List<dynamic> jsonData = json.decode(jsonStr);
  //     final sections = jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  //     emit(state.copyWith(status: FormStatus.success, sections: sections));
  //   } catch (e) {
  //     emit(state.copyWith(status: FormStatus.failure, errorMessage: e.toString()));
  //   }
  // }
}

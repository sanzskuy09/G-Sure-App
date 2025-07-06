part of 'form_bloc.dart';

class FormStateData extends Equatable {
  // Map ini akan menjadi satu-satunya sumber kebenaran untuk nilai form
  final Map<String, dynamic> formAnswers;

  const FormStateData({this.formAnswers = const {}});

  // Fungsi copyWith untuk membuat state baru tanpa mengubah yang lama (immutability)
  FormStateData copyWith({
    Map<String, dynamic>? formAnswers,
  }) {
    return FormStateData(
      formAnswers: formAnswers ?? this.formAnswers,
    );
  }

  @override
  List<Object> get props => [formAnswers];
}

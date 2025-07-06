part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
  @override
  List<Object> get props => [];
}

// Event ini dipanggil setiap kali sebuah field di-update
class UpdateFormValue extends FormEvent {
  final String key;
  final dynamic value;

  const UpdateFormValue(this.key, this.value);

  @override
  List<Object> get props => [key, value];
}

class LoadForm extends FormEvent {}

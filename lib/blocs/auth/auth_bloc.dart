import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gsure/models/login_model.dart';
import 'package:gsure/models/user_model.dart';
import 'package:gsure/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthLogin) {
          emit(AuthLoading());

          final res = await AuthServices().login(event.data);

          emit(AuthSuccess(res));
        }

        if (event is AuthGetUserCredential) {
          emit(AuthLoading());

          final LoginModel data = await AuthServices().loginFromCredential();

          final UserModel user = await AuthServices().login(data);

          emit(AuthSuccess(user));
        }

        if (event is AuthCheck) {
          emit(AuthLoading());

          final user = await AuthServices().verifyToken(event.token);

          emit(AuthSuccess(user));
        }

        // TAMBAHKAN HANDLER INI
        if (event is AuthCheckStatus) {
          if (state is AuthSuccess) {
            return;
          }

          try {
            emit(AuthLoading());
            final UserModel user = await AuthServices().getUserFromStorage();
            emit(AuthSuccess(user));
          } catch (e) {
            emit(AuthInitial());
          }
        }
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}

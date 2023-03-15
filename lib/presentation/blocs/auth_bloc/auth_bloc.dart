import 'dart:async';

import 'package:hokok/core/response_api_model.dart';
import 'package:hokok/data/models/user_model.dart';
import 'package:hokok/data/repositories/auth_api_repository.dart';
import 'package:hokok/domain/usecases/use_case_provider.dart';
import 'package:hokok/presentation/blocs/auth_bloc/auth-bloc_controller.dart';
import 'package:hokok/presentation/blocs/auth_bloc/auth_events.dart';
import 'package:hokok/presentation/blocs/auth_bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(AuthInitState()) {
    on<AuthSendOptEvent>(sendLoginOptCode);
    on<AuthRegisterEvent>(register);
  }
  final _controller = AuthBlocController.instance();

  Map<String, dynamic> _phoneMapModel() =>
      {"phone_number": _controller.phoneNumber};
  Map<String, dynamic> _userMapModel() =>
      UserModel.toJson(_controller.prepateUserModel());

  FutureOr<void> sendLoginOptCode(AuthEvents events, Emitter emit) async {
    emit(AuthLoadingState());
    Map<String, dynamic> result = await UseCaseProvider.instance()
        .creator<AuthApiRepository>(AuthApiRepository.instance())
        .loginOpt(_phoneMapModel());
    if (result[mapKey] == successReposne) {
      emit(AuthSuccessState());
    } else {
      emit(AuthFailedState(result[mapValue]));
    }
  }

  FutureOr<void> register(AuthEvents events, Emitter emit) async {
    emit(AuthLoadingState());
    Map<String, dynamic> result = await UseCaseProvider.instance()
        .creator<AuthApiRepository>(AuthApiRepository.instance())
        .register(_userMapModel());
    if (result[mapKey] == successReposne) {
      emit(AuthSuccessState());
    } else {
      emit(AuthFailedState(result[mapValue]));
    }
  }
}
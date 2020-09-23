import 'package:ayo/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'repository_state.dart';

class RepositoryCubit extends Cubit<RepositoryState> {
  final Repository repository;
  RepositoryCubit(this.repository) : super(RepositoryInitial(repository));
}

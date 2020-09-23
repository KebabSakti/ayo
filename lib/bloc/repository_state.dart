part of 'repository_cubit.dart';

abstract class RepositoryState extends Equatable {
  final Repository repository;
  const RepositoryState(this.repository);
}

class RepositoryInitial extends RepositoryState {
  RepositoryInitial(Repository repository) : super(repository);

  @override
  List<Object> get props => [];
}

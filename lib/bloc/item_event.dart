part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialItems extends ItemEvent {}

class AddToGroup extends ItemEvent {
  final int index;
  final int groupType;
  final IconData icon;

  AddToGroup(this.index, this.groupType, this.icon);

  @override
  List<Object> get props => [index, groupType, icon];
}

class RemoveFromGroup extends ItemEvent {
  final int index;
  final int groupType;

  RemoveFromGroup(this.index, this.groupType);

  @override
  List<Object> get props => [index, groupType];
}

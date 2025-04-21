part of 'item_bloc.dart';

class ItemState extends Equatable {
  final List<int> dataItems;
  final Map<int, List<int>> groups;
  final Map<int, int?> lastAddedItem;

  final int? lastAddedIndex;
  final int? lastRemovedIndex;

  const ItemState({
    required this.dataItems,
    required this.groups,
    required this.lastAddedItem,
    this.lastAddedIndex,
    this.lastRemovedIndex,
  });

  ItemState copyWith({
    List<int>? dataItems,
    Map<int, List<int>>? groups,
    Map<int, int?>? lastAddedItem,
    int? lastAddedIndex,
    int? lastRemovedIndex,
  }) {
    return ItemState(
      dataItems: dataItems ?? this.dataItems,
      groups: groups ?? this.groups,
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
      lastAddedIndex: lastAddedIndex,
      lastRemovedIndex: lastRemovedIndex,
    );
  }

  @override
  List<Object?> get props => [
    dataItems,
    groups,
    lastAddedIndex,
    lastRemovedIndex,
  ];
}
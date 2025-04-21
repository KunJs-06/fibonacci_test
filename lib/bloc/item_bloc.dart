import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(
    const ItemState(
      dataItems: [],
      groups: {
        0: [], // circle
        1: [], // crop
        2: [], // close
      },
      lastAddedItem: {0: null, 1: null, 2: null},
    ),
  ) {
    on<LoadInitialItems>((event, emit) {
      final items = List.generate(40, (i) => i);
      emit(state.copyWith(dataItems: items));
    });

    on<AddToGroup>((event, emit) {
      final currentGroup = state.groups[event.groupType]!;
      final updatedGroup = List<int>.from(currentGroup);
      final updatedItems = List<int>.from(state.dataItems);
      final updatedGroups = Map<int, List<int>>.from(state.groups)..[event.groupType] = updatedGroup;
      final updatedLastAddedItem = Map<int, int?>.from(state.lastAddedItem)..[event.groupType] = event.index;

      if (!updatedGroup.contains(event.index)) {
        updatedGroup.add(event.index);
        updatedItems.remove(event.index);
      }



      emit(state.copyWith(
        groups: updatedGroups,
        dataItems: updatedItems,
        lastAddedItem: updatedLastAddedItem,
      ));
    });

    on<RemoveFromGroup>((event, emit) {
      final updatedGroup = List<int>.from(state.groups[event.groupType]!);
      final updatedItems = List<int>.from(state.dataItems);
      final updatedGroups = Map<int, List<int>>.from(state.groups)..[event.groupType] = updatedGroup;

      updatedGroup.remove(event.index);
      if (!updatedItems.contains(event.index)) {
        updatedItems.add(event.index);
        updatedItems.sort();
      }

      emit(
        state.copyWith(
          groups: updatedGroups,
          dataItems: updatedItems,
          lastRemovedIndex: event.index,
          lastAddedIndex: null,
        ),
      );
    });
  }
}
import 'package:fibonacci_test/bloc/item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollControllerMain = ScrollController();

  int fibonacci(int n) {
    //ตัวเลขฟีโบนัชชีสร้างขึ้นโดยกำหนดให้ F 0 = 0, F 1 = 1 จากนั้นใช้สูตรเรียกซ้ำ F n  = F( n-1 ) + F (n-2) สูตรคำนวน
    if (n == 0 || n == 1) {
      return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
  }

  IconData getIcon(int i) {
    switch (i % 3) {
      case 0:
        return Icons.circle;
      case 1:
        return Icons.crop_square;
      default:
        return Icons.close;
    }
  }

  @override
  void dispose() {
    scrollControllerMain.dispose();
    super.dispose();
  }

  Future<void> _scrollToIndex(int index) async {
    final double offset = (index-1) * 50.0 ;
    await scrollControllerMain.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fibonacci number list"),centerTitle: true,backgroundColor: Colors.blueAccent,),
      body: BlocConsumer<ItemBloc, ItemState>(
        listenWhen: (prev, curr) {
          return prev.lastRemovedIndex != curr.lastRemovedIndex;
        },
        listener: (context, state) {
          if (state.lastRemovedIndex != null) {
            _scrollToIndex(state.lastRemovedIndex!);
          }
        },
        builder: (context, state) {
          return ListView.builder(
            controller: scrollControllerMain,
            itemCount: state.dataItems.length,
            itemExtent: 50.0,
            itemBuilder: (context, index) {
              final listItems = state.dataItems[index];
              final number = fibonacci(listItems);
              final icon = getIcon(number);
              return ListTile(
                tileColor: listItems == state.lastRemovedIndex ? Colors.red : Colors.white ,
                title: Text("Index ${listItems + 1} | Fibonacci $number"),
                trailing: Icon(icon),
                onTap: () {
                  final groupType = number % 3;
                  context.read<ItemBloc>().add(AddToGroup(listItems, groupType, icon));
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      final ScrollController scrollBottomSheet = ScrollController();
                      return  BlocBuilder<ItemBloc, ItemState>(
                        builder: (context, state) {
                          final group = List<int>.from(state.groups[groupType]!);
                          final last = state.lastAddedItem[groupType];
                          group.sort();
                          WidgetsBinding.instance.addPostFrameCallback((context) {
                            scrollBottomSheet.animateTo(
                              50,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                          return SizedBox(
                            height: 300,
                            width: MediaQuery.of(context).size.width ,
                            child: ListView.builder(
                              controller: scrollBottomSheet,
                              shrinkWrap: true,
                              itemCount: group.length,
                              itemBuilder: (context, index) {
                                final addItems = group[index];
                                final fib = fibonacci(addItems);
                                bool isLast = (addItems == last) ? true : false;
                                return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: group[0] == addItems ? BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ) : BorderRadius.zero,
                                    ),
                                    tileColor: isLast ? Colors.green : Colors.white,
                                    title: Text("Index ${addItems + 1} | Fibonacci $fib"),
                                    trailing: Icon(icon),
                                    onTap: () {
                                      context.read<ItemBloc>().add(RemoveFromGroup(addItems, groupType));
                                      Navigator.pop(context);
                                    },
                                  );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
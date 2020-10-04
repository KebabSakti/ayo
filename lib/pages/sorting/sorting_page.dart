import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/query/sorting.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  QueryCubit queryCubit;

  void _back() {
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    queryCubit.setQuery(
      QueryModel(
        filter: queryCubit.state.query.filter,
        sorting: Sorting(),
      ),
    );
  }

  @override
  void initState() {
    queryCubit = context.bloc<QueryCubit>();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sorting',
          style: TextStyle(color: Colors.grey[800]),
        ),
        leading: IconButton(
          onPressed: () {
            _back();
          },
          icon: Icon(Icons.close),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.white,
        actions: [
          FlatButton(
            onPressed: () {
              _resetFilter();
            },
            child: Text(
              'Reset',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<QueryCubit, QueryState>(
        listener: (context, state) {
          if (state is! QueryLoading) _back();
        },
        builder: (context, state) {
          var filter = state.query.filter;
          var sorting = state.query.sorting;
          return ListView(
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    queryCubit.setQuery(QueryModel(
                      filter: filter,
                      sorting: sorting.copyWith(sorting: 'latest'),
                    ));
                  },
                  title: Text('Terbaru'),
                  trailing: sorting.sorting == 'latest'
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 1,
                width: double.infinity,
              ),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    queryCubit.setQuery(QueryModel(
                      filter: filter,
                      sorting: sorting.copyWith(sorting: 'expensive'),
                    ));
                  },
                  title: Text('Harga Tertinggi'),
                  trailing: sorting.sorting == 'expensive'
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 1,
                width: double.infinity,
              ),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    queryCubit.setQuery(QueryModel(
                      filter: filter,
                      sorting: sorting.copyWith(sorting: 'cheapest'),
                    ));
                  },
                  title: Text('Harga Terendah'),
                  trailing: sorting.sorting == 'cheapest'
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 1,
                width: double.infinity,
              ),
            ],
          );
        },
      ),
    );
  }
}

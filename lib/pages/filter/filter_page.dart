import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/util/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  QueryCubit queryCubit;

  double _limitMinPrice = 1000;
  double _limitMaxPrice = 500000;

  TextEditingController _hargaMin = TextEditingController();
  TextEditingController _hargaMax = TextEditingController();

  void _back() {
    Navigator.of(context).pop();
  }

  void _resetFilter() {
    queryCubit.setQuery(
      QueryModel(
        filter: Filter(),
        sorting: queryCubit.state.query.sorting,
      ),
    );
  }

  void _hargaMinListener() {
    if (_hargaMin.text.isNotEmpty) {
      if (double.parse(_hargaMin.text) >= _limitMinPrice &&
          double.parse(_hargaMin.text) <= _limitMaxPrice) {
        queryCubit.setQuery(
          QueryModel(
            filter: queryCubit.state.query.filter.copyWith(
              hargaMin: double.parse(_hargaMin.text),
            ),
            sorting: queryCubit.state.query.sorting,
          ),
        );
      }
    }
  }

  void _hargaMaxListener() {
    if (_hargaMax.text.isNotEmpty) {
      if (double.parse(_hargaMax.text) >
              queryCubit.state.query.filter.hargaMin &&
          double.parse(_hargaMax.text) <= _limitMaxPrice) {
        queryCubit.setQuery(
          QueryModel(
            filter: queryCubit.state.query.filter.copyWith(
              hargaMax: double.parse(_hargaMax.text),
            ),
            sorting: queryCubit.state.query.sorting,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    queryCubit = context.bloc<QueryCubit>();

    _hargaMin.text = queryCubit.state.query.filter.hargaMin?.toString() ??
        _limitMinPrice.toString();
    _hargaMax.text = queryCubit.state.query.filter.hargaMax?.toString() ??
        _limitMaxPrice.toString();

    super.initState();
  }

  @override
  void dispose() {
    _hargaMin.dispose();
    _hargaMax.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter',
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
          if (state is! QueryLoading) {
            _hargaMin.text = state.query.filter.hargaMin == null
                ? _limitMinPrice.toString()
                : state.query.filter.hargaMin.toString();
            _hargaMax.text = state.query.filter.hargaMax == null
                ? _limitMaxPrice.toString()
                : state.query.filter.hargaMax.toString();
          }
        },
        builder: (context, state) {
          var filter = state.query.filter;
          var sorting = state.query.sorting;
          return ListView(
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: SwitchListTile(
                  onChanged: (value) {
                    queryCubit.setQuery(QueryModel(
                      filter: filter.copyWith(terlaris: value ? 1 : 0),
                      sorting: sorting,
                    ));
                  },
                  value: filter.terlaris == 1 ? true : false,
                  title: Text(
                    'Produk yang paling laku',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
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
                child: SwitchListTile(
                  onChanged: (value) {
                    queryCubit.setQuery(QueryModel(
                      filter: filter.copyWith(diskon: value ? 1 : 0),
                      sorting: sorting,
                    ));
                  },
                  value: filter.diskon == 1 ? true : false,
                  title: Text(
                    'Yang lagi diskon',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
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
                child: SwitchListTile(
                  onChanged: (value) {
                    queryCubit.setQuery(QueryModel(
                      filter: filter.copyWith(search: value ? 1 : 0),
                      sorting: sorting,
                    ));
                  },
                  value: filter.search == 1 ? true : false,
                  title: Text(
                    'Paling banyak di cari',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
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
                child: SwitchListTile(
                  onChanged: (value) {
                    queryCubit.setQuery(QueryModel(
                      filter: filter.copyWith(view: value ? 1 : 0),
                      sorting: sorting,
                    ));
                  },
                  value: filter.view == 1 ? true : false,
                  title: Text(
                    'Yang lagi trending',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
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
                child: SwitchListTile(
                  onChanged: (value) {
                    queryCubit.setQuery(QueryModel(
                      filter: filter.copyWith(rating: value ? 4 : 0),
                      sorting: sorting,
                    ));
                  },
                  value: filter.rating == 4 ? true : false,
                  title: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '4 ke atas',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
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
                  title: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jenis Pengiriman',
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  queryCubit.setQuery(QueryModel(
                                    filter: filter.copyWith(
                                      pengiriman: filter.pengiriman == 'instant'
                                          ? ''
                                          : 'instant',
                                    ),
                                    sorting: sorting,
                                  ));
                                },
                                borderRadius: BorderRadius.circular(15),
                                splashColor: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.3),
                                child: Ink(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: filter.pengiriman == null
                                        ? Colors.white
                                        : filter.pengiriman == 'instant'
                                            ? Theme.of(context).accentColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Instant',
                                      style: TextStyle(
                                        color: filter.pengiriman == null
                                            ? Theme.of(context).accentColor
                                            : filter.pengiriman == 'instant'
                                                ? Colors.white
                                                : Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  queryCubit.setQuery(QueryModel(
                                    filter: filter.copyWith(
                                      pengiriman:
                                          filter.pengiriman == 'terjadwal'
                                              ? ''
                                              : 'terjadwal',
                                    ),
                                    sorting: sorting,
                                  ));
                                },
                                borderRadius: BorderRadius.circular(15),
                                splashColor: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.3),
                                child: Ink(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: filter.pengiriman == null
                                        ? Colors.white
                                        : filter.pengiriman == 'terjadwal'
                                            ? Theme.of(context).accentColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Terjadwal',
                                      style: TextStyle(
                                        color: filter.pengiriman == null
                                            ? Theme.of(context).accentColor
                                            : filter.pengiriman == 'terjadwal'
                                                ? Colors.white
                                                : Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.help,
                      color: Colors.grey[800],
                      size: 20,
                    ),
                  ),
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
                  title: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Harga Min',
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              'Harga Max',
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _hargaMin,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 14),
                                keyboardType: TextInputType.number,
                                onEditingComplete: _hargaMinListener,
                                decoration: InputDecoration(
                                  hintText: '$_limitMinPrice',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: _hargaMax,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 14),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                onEditingComplete: _hargaMaxListener,
                                decoration: InputDecoration(
                                  hintText: '$_limitMaxPrice',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        FlutterSlider(
                          values: [
                            filter.hargaMin ?? _limitMinPrice,
                            filter.hargaMax ?? _limitMaxPrice
                          ],
                          rangeSlider: true,
                          min: _limitMinPrice,
                          max: _limitMaxPrice,
                          step: FlutterSliderStep(step: 1000),
                          trackBar: FlutterSliderTrackBar(
                            activeTrackBar: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          tooltip: FlutterSliderTooltip(
                            textStyle:
                                TextStyle(fontSize: 10, color: Colors.white),
                            disabled: true,
                            alwaysShowTooltip: false,
                            positionOffset:
                                FlutterSliderTooltipPositionOffset(top: 0),
                            boxStyle: FlutterSliderTooltipBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            format: (String value) {
                              return Helper()
                                  .getFormattedNumber(double.parse(value));
                            },
                          ),
                          onDragCompleted:
                              (handlerIndex, lowerValue, upperValue) {
                            queryCubit.setQuery(
                              QueryModel(
                                filter: filter.copyWith(
                                  hargaMin: lowerValue,
                                  hargaMax: upperValue,
                                ),
                                sorting: sorting,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 1,
                width: double.infinity,
              ),
              SizedBox(
                height: 56,
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 56,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 6.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: FlatButton(
          onPressed: () {
            _back();
          },
          padding: EdgeInsets.zero,
          child: Ink(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                'Tampilkan Produk',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

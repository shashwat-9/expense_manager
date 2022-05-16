import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './Widgets/new_transaction.dart';
import './models/transactions.dart';
import './Widgets/transaction_list.dart';
import './Widgets/chart.dart';

void main() {
//   WidgetsFlutterBinding
//       .ensureInitialized(); //required before using app-wide restriction/feature
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Color.fromARGB(255, 0, 32, 212),
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline3: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'abc',
            fontSize: 30,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // final titleController = TextEditingController();

  // final amountController = TextEditingController();
  final List<Transaction> _userTransactions = [
    /*Transaction(
      id: 't1',
      title: 'Shoes',
      amount: 24,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Shirts',
      amount: 25,
      date: DateTime.now(),
    ),*/
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(tx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransactions(_addNewTransactions);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  var _showChart = false;

  Widget _builderCupertinoNavigation() {
    return CupertinoNavigationBar(
      middle: Text('Flutter App'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          child: Icon(CupertinoIcons.add),
          onTap: () => _startAddNewTransaction(context),
        )
      ]),
    );
  }

  Widget _builderAppBar(final currScale) {
    return AppBar(
      title: Text("Flutter App", style: TextStyle(fontSize: 20 * currScale)),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  List<Widget> _builderLandscape(AppBar appBar, final txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline3,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.8,
              child: Chart(_recentTransactions))
          : txList,
    ];
  }

  List<Widget> _builderPortrait(AppBar appBar, final txList) {
    return [
      Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txList
    ];
  }

  Widget build(BuildContext context) {
    final currScale = MediaQuery.of(context).textScaleFactor;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _builderAppBar(currScale);

    // Platform.isIOS
    //     ? _builderCupertinoNavigation()
    //     : _builderAppBar(currScale);

    final txList = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final appBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          // child:
          if (isLandScape) ..._builderLandscape(appBar, txList),
          if (!isLandScape)
            if (!isLandScape) txList,
          // if (isLandScape) ..._builderLandscape(appBar, txList),
          // SizedBox(
          //   height: 200,
          // )
        ],
      ),
    ));

    return Scaffold(
      appBar: appBar,
      body: appBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context)),
      // floatingActionButton: Platform.isIOS
      //     ? Container()
      //     : FloatingActionButton(
      //         child: Icon(Icons.add),
      //         onPressed: () => _startAddNewTransaction(context)),
    );
    // : Platform.isIOS
    //     ? CupertinoPageScaffold(child: appBody)
    //     : Scaffold(
    //         appBar: appBar,
    //         body: appBody,
    //         floatingActionButtonLocation:
    //             FloatingActionButtonLocation.centerDocked,
    //         floatingActionButton: Platform.isIOS
    //             ? Container()
    //             : FloatingActionButton(
    //                 child: Icon(Icons.add),
    //                 onPressed: () => _startAddNewTransaction(context)),
    //       );
  }
}

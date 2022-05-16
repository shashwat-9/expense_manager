import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTrnx;

  TransactionList(this.transactions, this.deleteTrnx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Container(
                height: constraints.maxHeight,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("No Transaction Yet"),
                    SizedBox(height: 10),
                    Container(
                      height: constraints.maxHeight *
                          0.6, //DO look for why it fails for x = 1
                      child: Image.asset(
                        'assets/Images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                /*return Card(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2.4,
                          ),
                        ),
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                          //{tx.amount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Text(
                              transactions[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            //tx.date.toString(),
                            DateFormat.yMMMd().format(
                              transactions[index].date,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );*/
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            '\$${transactions[index].amount}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(transactions[index].title),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? FlatButton.icon(
                            label: Text(
                              'Delete',
                            ),
                            textColor: Theme.of(context).errorColor,
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteTrnx(transactions[index].id),
                          )
                        : IconButton(
                            onPressed: () => deleteTrnx(transactions[index].id),
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}

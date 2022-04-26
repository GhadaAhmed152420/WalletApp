import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app/controllers/db_helper.dart';
import 'package:wallet_app/views/add_transaction.dart';
import 'package:wallet_app/viewmodels/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  var vm = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const AddTransaction()))
                .whenComplete(() {
              setState(() {});
            });
          },
          backgroundColor: Colors.purple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: const Icon(
            Icons.add,
            size: 32.0,
          )),
      body: FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unexpected Error !'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 500,
                    width: 500,
                    child: Column(
                      children: [
                        Image.asset('images/Research paper-amico.png'),
                        const SizedBox(height: 20.0,),
                        const Text('No values found !', style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
              );
            }
            vm.getTotalBalance(snapshot.data!);
            vm.getPlotPoints(snapshot.data!);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Hello!',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Ghada Ahmed ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Stack(children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.notifications_none),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 5.0,
                                backgroundColor: Colors.red,
                              ),
                            )
                          ],),
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.deepPurple,
                          Colors.purple,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          '\$ ${vm.totalBalance.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              vm.cardIncome(vm.totalIncome.toString()),
                              vm.cardExpense(vm.totalExpense.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 40.0,
                    ),
                    margin: const EdgeInsets.all(12.0),
                    height: 400.0,
                    child: LineChart(LineChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: vm.getPlotPoints(snapshot.data!),
                            isCurved: false,
                            barWidth: 2.5,
                            colors: [Colors.purple],
                          )
                        ])),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map dataAtIndex = snapshot.data![index];
                        if (dataAtIndex['type'] == 'Income') {
                          return vm.incomeTile(
                              dataAtIndex['amount'], dataAtIndex['note']);
                        } else {
                          return vm.expenseTile(
                              dataAtIndex['amount'], dataAtIndex['note']);
                        }
                      }),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Unexpected Error !'),
            );
          }
        },
      ),
    );
  }
}

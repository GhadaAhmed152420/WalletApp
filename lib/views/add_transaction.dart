import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/controllers/db_helper.dart';
import 'package:wallet_app/viewmodels/add_transaction_view_model.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var vm = AddTransactionViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Add Transaction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.attach_money,
                    size: 24.0,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    vm.onChangeMoney(context, val);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.description,
                    size: 24.0,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Note on transaction',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    vm.note = val;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.moving_sharp,
                    size: 24.0,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: vm.type == "Income" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Colors.purple,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      vm.type = "Income";
                    });
                  }
                },
                selected: vm.type == "Income" ? true : false,
              ),
              const SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                label: Text(
                  "Expense",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: vm.type == "Expense" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Colors.purple,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      vm.type = "Expense";
                    });
                  }
                },
                selected: vm.type == "Expense" ? true : false,
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
              height: 50.0,
              child: TextButton(
                  onPressed: () {
                    vm.selectDate(context).whenComplete(() {
                      setState(() {});
                    });
                    FocusScope.of(context).unfocus();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.zero,
                      ),
                  ),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.date_range,
                            size: 24.0,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        '${vm.selectedDate.day} ${vm.months[vm.selectedDate.month - 1]}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )
              )
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: () async {
                 if(vm.amount != null && vm.note.isNotEmpty){
                   DbHelper dbHelper = DbHelper();
                   await dbHelper.addData(vm.amount!, vm.note, vm.selectedDate, vm.type);
                   Navigator.of(context).pop(context);
                 }else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       backgroundColor: Colors.red[700],
                       content: const Text(
                         "Please enter a valid Amount !",
                         style: TextStyle(
                           fontSize: 16.0,
                           color: Colors.white,
                         ),
                       ),
                     ),
                   );
                 }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          )
        ],
      ),
    );
  }
}


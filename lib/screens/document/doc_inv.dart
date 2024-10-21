import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/doc/doc_inv.dart';
import 'package:flutter_savdogar/screens/document/doc_inv_add.dart';
import 'package:flutter_savdogar/share/utils.dart';

class DocInvPage extends StatefulWidget {
  const DocInvPage({super.key});

  @override
  State<DocInvPage> createState() => _DocInvPageState();
}

class _DocInvPageState extends State<DocInvPage> {
  List<DocInv> invList = [];
  int tabIndex = 0;

  bool defaultSort = true;
  bool alphabetSort = true;
  bool sumSort = true;
  bool allDocuments = true;
  bool newDocuments = true;
  bool acceptedDocuments = true;

  @override
  void initState() {
    super.initState();
    invList = [
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
      DocInv(
        id: 0,
        typeId: 0,
        curdate: "07.10.2024",
        curtime: "",
        contraId: 0,
        notes: "Kukmara Uzbekiston",
        itogSumm: 48540000,
        itogStdSumm: 26,
        itogKg: 2,
        itogCase: 0,
        itogPc: 0,
        curtime1: "",
        whId: 0,
        isPrinted: 1,
        xarajat: 125,
        srok: "KKK",
        skidka: 2,
        priceIndex: 2,
        toWhId: 1,
        hasError: true,
        reys: 1,
        bnProcent: 2,
        myUIID: "adshgbdb78787cbsdhbc90i0ibdcds0098",
        isCur: 0,
        curRate: 2.5,
        docNum: 0,
        annul: true,
        userId: 1,
        isRass: 1,
        rassDate: "",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Документы склада"),
        actions: [
          IconButton(
              onPressed: () {
                getFilteredButton();
              },
              icon: const Icon(Icons.filter_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_downward, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Приходы"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_upward, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Расходы"),
          BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_left, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Возвраты"),
          BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_right, color: tabIndex == 3 ? Colors.white : Colors.white30), label: "Бракы"),
        ],
        onTap: (value) {
          tabIndex = value;
          setState(() {});
        },
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DocInvAdd(invType: "Новый приход")));
        },
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
        child: const Icon(Icons.add),
      ),
    );
  }

  getBody() {
    return ListView.builder(
      itemCount: invList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: index % 2 == 0 ? Theme.of(context).colorScheme.outline.withAlpha(90) : Colors.green.shade300,
                width: 5,
                style: BorderStyle.solid,
              ),
            ),
            color: index % 2 == 0 ? Theme.of(context).colorScheme.outline.withAlpha(30) : Colors.green.withAlpha(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(invList[index].notes, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(invList[index].curdate, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400, color: Colors.grey)),
                  const Spacer(),
                  Text(
                    Utils.myNumFormat0(invList[index].itogSumm),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Примечание:", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.grey)),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(index % 2 == 0 ? Icons.done : Icons.done_all, color: index % 2 == 0 ? Colors.grey : Colors.green, size: 20),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  getFilteredButton() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: const Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(decoration: InputDecoration(labelText: 'Период с', hintText: 'mm/dd/yyyy', border: OutlineInputBorder())),
                SizedBox(height: 20),
                TextField(decoration: InputDecoration(labelText: 'по', hintText: 'mm/dd/yyyy', border: OutlineInputBorder())),
              ],
            ),
            content: Column(
              children: [
                Text('Сортировать', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 16),
                getCheckbox('По умолчание', defaultSort, () {
                  setState(() {
                    defaultSort = !defaultSort;
                  });
                }),
                getCheckbox('Алфавиту', alphabetSort, () {
                  setState(() {
                    alphabetSort = !alphabetSort;
                  });
                }),
                getCheckbox('Сумма', sumSort, () {
                  setState(() {
                    sumSort = !sumSort;
                  });
                }),
                const Divider(),
                const SizedBox(height: 16),
                Text('Статус', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 10),
                getCheckbox('Все документы', allDocuments, () {
                  setState(() {
                    allDocuments = !allDocuments;
                  });
                }),
                getCheckbox('Новый', newDocuments, () {
                  setState(() {
                    newDocuments = !newDocuments;
                  });
                }),
                getCheckbox('Принятые', acceptedDocuments, () {
                  setState(() {
                    acceptedDocuments = !acceptedDocuments;
                  });
                }),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), backgroundColor: Colors.blue),
                  child: Text('Просмотр', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  getCheckbox(String text, bool filteredType, Function func) {
    return CheckboxListTile(
      title: Text(text, style: Theme.of(context).textTheme.titleMedium),
      value: filteredType,
      onChanged: (newValue) {
        func();
      },
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}

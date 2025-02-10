import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';
import 'package:flutter_savdogar/model/doc/doc_inv_list.dart';
import 'package:flutter_savdogar/screens/docs/inv/doc_inv_provider.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

class EditInvList extends StatefulWidget {
  final DicProd? dicProd;
  final DocInvList? docInvList;

  const EditInvList({super.key, this.dicProd, this.docInvList});

  @override
  State<EditInvList> createState() => _EditInvListState();
}

class _EditInvListState extends State<EditInvList> {
  TextEditingController qty = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController summ = TextEditingController();

  @override
  void initState() {
    if (widget.docInvList != null) {
      qty.text = Utils.myNumFormat2(widget.docInvList!.qty);
      price.text = Utils.myNumFormat2(widget.docInvList!.price);
      summ.text = Utils.myNumFormat2(widget.docInvList!.summ);
    }
    if (widget.dicProd != null) {
      price.text = widget.dicProd!.price1.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final docInvProvider = Provider.of<DocInvProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.dicProd != null ? Text(widget.dicProd!.name) : Text(widget.docInvList!.prodName),
        actions: [
          IconButton(
            onPressed: () {
              double summ = docInvProvider.invList.fold(0, (a, value) => a + value.summ);
              docInvProvider.price.text = summ.toString();
              addInvList(docInvProvider);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.redAccent.shade100, borderRadius: BorderRadius.circular(10)),
              child: Text("Остаток: 3", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: qty,
              autofocus: true,
              onChanged: (value) {
                summ.text = Utils.myNumFormat2(Utils.parseFormattedCurrency(qty.text) * Utils.parseFormattedCurrency(price.text));
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: "Количество",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                errorStyle: const TextStyle(fontSize: 12, height: 0.8),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: price,
              onChanged: (value) {
                summ.text = Utils.myNumFormat2(Utils.parseFormattedCurrency(qty.text) * Utils.parseFormattedCurrency(price.text));
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: "Цена",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                errorStyle: const TextStyle(fontSize: 12, height: 0.8),
              ),
              inputFormatters: [CurrencyInputFormatter()],
            ),
            SizedBox(height: 15),
            TextFormField(
              readOnly: true,
              controller: summ,
              decoration: InputDecoration(
                labelText: "Сумма",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                errorStyle: const TextStyle(fontSize: 12, height: 0.8),
              ),
              inputFormatters: [CurrencyInputFormatter()],
            )
          ],
        ),
      ),
    );
  }

  void addInvList(DocInvProvider docInvProvider) {
    if (qty.text.isEmpty || price.text.isEmpty) {
      return;
    }
    DocInvList newItem = DocInvList(
      id: widget.docInvList != null ? widget.docInvList!.id : docInvProvider.invList.length + 1,
      invId: 0,
      prodId: widget.docInvList != null ? widget.docInvList!.prodId : widget.dicProd!.id,
      qty: Utils.checkDouble(qty.text),
      qtyCase: 0.0,
      price: Utils.parseFormattedCurrency(price.text),
      summ: Utils.parseFormattedCurrency(summ.text),
      priceStd: 0.0,
      status: 1,
      listNum: 1,
      partyPrice: 0.0,
      myUUID: "",
      prodId2: widget.docInvList != null ? widget.docInvList!.prodId : widget.dicProd!.id,
      prodHeight: 0.0,
      prodWidth: 0.0,
      prodQty: 0.0,
      ostQty: 0.0,
      prodName: widget.docInvList != null ? widget.docInvList!.prodName : widget.dicProd!.name,
    );
    docInvProvider.invList.add(newItem);

    Navigator.pop(context);
  }
}

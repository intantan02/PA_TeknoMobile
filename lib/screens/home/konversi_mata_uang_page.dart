import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rekomendasi_buku/services/currency_service.dart';

class KonversiMataUangPage extends StatefulWidget {
  @override
  _KonversiMataUangPageState createState() => _KonversiMataUangPageState();
}

class _KonversiMataUangPageState extends State<KonversiMataUangPage> {
  final CurrencyService _currencyService = CurrencyService();
  final TextEditingController _amountController = TextEditingController();

  String _from = 'USD';
  String _to = 'IDR';
  String _result = '';
  late List<String> _currencies;
  final NumberFormat _formatter = NumberFormat("#,##0", "id_ID");

  @override
  void initState() {
    super.initState();
    _currencies = _currencyService.currencies;
    if (!_currencies.contains(_from)) _from = _currencies.first;
    if (!_currencies.contains(_to)) _to = _currencies.first;
  }

  void _convert() {
    final rawText = _amountController.text.replaceAll('.', '');
    final amount = double.tryParse(rawText);
    if (amount == null) {
      setState(() => _result = 'Masukkan jumlah yang valid');
      return;
    }

    try {
      final converted = _currencyService.convert(_from, _to, amount);
      final formattedInput = _formatter.format(amount);
      final formattedOutput = _formatter.format(converted);

      setState(() {
        _result = '$formattedInput $_from = $formattedOutput $_to';
      });
    } catch (e) {
      setState(() => _result = 'Error konversi: $e');
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
    _convert();
  }

  Future<void> _showCurrencySearchDialog({
    required String title,
    required String selectedCurrency,
    required Function(String) onCurrencySelected,
  }) async {
    List<String> filteredCurrencies = List.from(_currencies);
    String searchText = '';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Pilih $title'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari mata uang',
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      searchText = value.toUpperCase();
                      setStateDialog(() {
                        filteredCurrencies = _currencies
                            .where((c) => c.contains(searchText))
                            .toList();
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: ListView(
                      children: filteredCurrencies
                          .map((c) => ListTile(
                                title: Text(c),
                                onTap: () {
                                  onCurrencySelected(c);
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Konversi Mata Uang'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (digits.isEmpty) return;
                final formatted = _formatter.format(int.parse(digits));
                _amountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCurrencySearchDialog(
                      title: 'Mata Uang Asal',
                      selectedCurrency: _from,
                      onCurrencySelected: (val) => setState(() => _from = val),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_from),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, size: 32),
                  onPressed: _swapCurrencies,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCurrencySearchDialog(
                      title: 'Mata Uang Tujuan',
                      selectedCurrency: _to,
                      onCurrencySelected: (val) => setState(() => _to = val),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_to),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Konversi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

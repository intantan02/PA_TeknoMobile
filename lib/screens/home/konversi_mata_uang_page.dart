import 'package:flutter/material.dart';
import 'package:rekomendasi_buku/services/currency_service.dart';

class KonversiMataUangPage extends StatefulWidget {
  @override
  _KonversiMataUangPageState createState() => _KonversiMataUangPageState();
}

class _KonversiMataUangPageState extends State<KonversiMataUangPage> {
  final CurrencyService _currencyService = CurrencyService();
  final TextEditingController _amountController = TextEditingController();

  String _from = 'IDR';
  String _to = 'USD';
  String _result = '';

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _result = 'Masukkan jumlah yang valid';
      });
      return;
    }

    final result = _currencyService.convert(_from, _to, amount);
    setState(() {
      _result = '$amount $_from = ${result.toStringAsFixed(2)} $_to';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konversi Mata Uang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDropdown('Dari', _from, (val) {
                  if (val != null) setState(() => _from = val);
                })),
                SizedBox(width: 16),
                Expanded(child: _buildDropdown('Ke', _to, (val) {
                  if (val != null) setState(() => _to = val);
                })),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _convert, child: Text('Konversi')),
            SizedBox(height: 24),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          items: ['IDR', 'USD', 'GBP']
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

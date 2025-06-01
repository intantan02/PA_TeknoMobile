import 'package:flutter/material.dart';
import '../../services/currency_service.dart';

class CurrencyConversionPage extends StatefulWidget {
  @override
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  final CurrencyService _currencyService = CurrencyService();

  final List<String> _currencies = ['IDR', 'USD', 'GBP'];
  String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';
  double _inputAmount = 0;
  double _convertedAmount = 0;

  final TextEditingController _controller = TextEditingController();

  void _convert() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _convertedAmount = 0;
      });
      return;
    }
    final result = _currencyService.convert(_fromCurrency, _toCurrency, input);
    setState(() {
      _inputAmount = input;
      _convertedAmount = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      items: _currencies
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Mata Uang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _convert(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Dari'),
                    _buildDropdown(_fromCurrency, (val) {
                      if (val != null) {
                        setState(() {
                          _fromCurrency = val;
                          _convert();
                        });
                      }
                    }),
                  ],
                ),
                Column(
                  children: [
                    Text('Ke'),
                    _buildDropdown(_toCurrency, (val) {
                      if (val != null) {
                        setState(() {
                          _toCurrency = val;
                          _convert();
                        });
                      }
                    }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              '$_inputAmount $_fromCurrency = $_convertedAmount $_toCurrency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

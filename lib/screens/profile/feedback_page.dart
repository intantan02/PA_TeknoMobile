import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _apiService.sendFeedback(_feedbackController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback berhasil dikirim')),
      );
      _feedbackController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim feedback')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirim Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Tulis feedback Anda',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Feedback tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitFeedback,
                      child: Text('Kirim'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

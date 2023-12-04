import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailSender {
  static Future<void> sendEmail({
    String? name,
    String? email,
    String? subject,
    String? message,
  }) async {
    final service_id = 'service_s88e2p2';
    final template_id = 'template_9vdqusx';
    final user_id = '0Ts1Uaskm14Kbgj-i';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': service_id,
        'template_id': template_id,
        'user_id': user_id,
        "template_params": {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        },
      }),
    );
    print(response.body);
  }
}

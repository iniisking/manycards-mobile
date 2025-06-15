class PaystackWebhookReq {
  final String event;
  final Data data;

  PaystackWebhookReq({required this.event, required this.data});

  Map<String, dynamic> toJson() {
    return {'event': event, 'data': data.toJson()};
  }
}

class Data {
  final String reference;
  final int amount;
  final String currency;
  final String status;
  final Customer customer;
  final Metadata metadata;
  final DateTime paidAt;

  Data({
    required this.reference,
    required this.amount,
    required this.currency,
    required this.status,
    required this.customer,
    required this.metadata,
    required this.paidAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'amount': amount,
      'currency': currency,
      'status': status,
      'customer': customer.toJson(),
      'metadata': metadata.toJson(),
      'paid_at': paidAt.toIso8601String(),
    };
  }
}

class Customer {
  final String email;
  final String phone;

  Customer({required this.email, required this.phone});

  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }
}

class Metadata {
  final List<CustomField> customFields;

  Metadata({required this.customFields});

  Map<String, dynamic> toJson() {
    return {
      'custom_fields': customFields.map((field) => field.toJson()).toList(),
    };
  }
}

class CustomField {
  final String variableName;
  final String value;
  final String displayName;

  CustomField({
    required this.variableName,
    required this.value,
    required this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'variable_name': variableName,
      'value': value,
      'display_name': displayName,
    };
  }
}

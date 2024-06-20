import 'package:flutter/foundation.dart';

class Ticket {
  final String movieTitle;
  final String cinema;
  final String date;
  final String time;
  final String studio;
  final List<String> seats;
  final double ticketPrice;
  final double admFee;
  final double promo;
  final double totalPayment;
  final String imageUrl;

  Ticket({
    required this.movieTitle,
    required this.cinema,
    required this.date,
    required this.time,
    required this.studio,
    required this.seats,
    required this.ticketPrice,
    required this.admFee,
    required this.promo,
    required this.totalPayment,
    required this.imageUrl,
  });
}

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => _tickets;

  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }
}

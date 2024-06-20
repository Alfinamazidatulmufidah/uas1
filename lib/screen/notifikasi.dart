import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ticket_page.dart';
import 'barcode_page.dart';

class NotifikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tickets = Provider.of<TicketProvider>(context).tickets;

    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        title: Text('Notifikasi'),
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Pembelian tiket ${ticket.movieTitle}'),
            subtitle: Text(
                'Studio: ${ticket.studio}, Kursi: ${ticket.seats.join(', ')}\nTotal Bayar: Rp ${ticket.totalPayment.toStringAsFixed(0)}'),
            onTap: () {
              // Aksi ketika notifikasi di tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarcodePage(
                    movieTitle: ticket.movieTitle,
                    cinema: ticket.cinema,
                    date: ticket.date,
                    time: ticket.time,
                    studio: ticket.studio,
                    seats: ticket.seats,
                    ticketPrice: ticket.ticketPrice,
                    admFee: ticket.admFee,
                    promo: ticket.promo,
                    totalPayment: ticket.totalPayment,
                    imageUrl: ticket.imageUrl,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

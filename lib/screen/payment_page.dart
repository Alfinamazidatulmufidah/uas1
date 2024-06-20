import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'barcode_page.dart';
import 'ticket_page.dart';

class PaymentPage extends StatelessWidget {
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

  PaymentPage({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
        title: Text('Konfirmasi Pemesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Unable to load image');
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieTitle,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(cinema),
                      Text('Tanggal: $date'),
                      Text('Jam: $time'),
                      Text('Studio: $studio'),
                      Text('Kursi: ${seats.join(', ')}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Harga Tiket: Rp ${ticketPrice.toStringAsFixed(0)} x ${seats.length} = Rp ${(ticketPrice * seats.length).toStringAsFixed(0)}',
            ),
            Text('Admin: Rp ${admFee.toStringAsFixed(0)}'),
            Text('Promo: Rp ${promo.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.red)),
            const Divider(),
            Text('Total Bayar: Rp ${totalPayment.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(), // Menambah Spacer untuk mendorong tombol ke bawah
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5, // Menambahkan bayangan pada tombol
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                onPressed: () {
                  // Add ticket to the provider
                  Provider.of<TicketProvider>(context, listen: false).addTicket(
                    Ticket(
                      movieTitle: movieTitle,
                      cinema: cinema,
                      date: date,
                      time: time,
                      studio: studio,
                      seats: seats,
                      ticketPrice: ticketPrice,
                      admFee: admFee,
                      promo: promo,
                      totalPayment: totalPayment,
                      imageUrl: imageUrl,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarcodePage(
                        movieTitle: movieTitle,
                        cinema: cinema,
                        date: date,
                        time: time,
                        studio: studio,
                        seats: seats,
                        ticketPrice: ticketPrice,
                        admFee: admFee,
                        promo: promo,
                        totalPayment: totalPayment,
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Konfirmasi Pemesanan',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Menambah jarak di bawah tombol
          ],
        ),
      ),
    );
  }
}

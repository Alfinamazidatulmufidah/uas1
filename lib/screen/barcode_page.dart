import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notifikasi.dart';

class BarcodePage extends StatelessWidget {
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

  BarcodePage({
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
      backgroundColor:
          Color.fromRGBO(239, 247, 255, 1), // Menambahkan warna latar belakang
      appBar: AppBar(
        title: const Text('Pembayaran Berhasil'),
        backgroundColor: Color.fromRGBO(
            239, 247, 255, 1), // Menambahkan warna latar belakang AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data:
                        'Tiket Film $movieTitle\nTotal Bayar: Rp ${totalPayment.toStringAsFixed(0)}',
                    width: 150,
                    height: 150,
                    backgroundColor: Colors
                        .white, // Menambahkan warna latar belakang QR Code
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please scan QR Code to collect your tickets at the theater.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 4, 51, 117)), // Mengubah warna teks menjadi putih
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Detail Transaksi',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 51, 117)),
            ),
            const Divider(
                color:
                    Colors.white), // Mengubah warna garis pemisah menjadi putih
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Unable to load image',
                        style: TextStyle(
                            color: Colors
                                .white)); // Mengubah warna teks error menjadi putih
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
                            color: Color.fromARGB(255, 4, 51, 117)),
                      ),
                      const SizedBox(height: 8),
                      Text(cinema, style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
                      Text('Tanggal: $date',
                          style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
                      Text('Jam: $time', style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
                      Text('Studio: $studio',
                          style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
                      Text('Kursi: ${seats.join(', ')}',
                          style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Transaction Ref: TMRCNB/RES/02-2024/01922',
                style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
            Text(
              'Harga Tiket: Rp ${ticketPrice.toStringAsFixed(0)} x ${seats.length} = Rp ${(ticketPrice * seats.length).toStringAsFixed(0)}',
              style: TextStyle(color: Color.fromARGB(255, 4, 51, 117)),
            ),
            Text('Admin: Rp ${admFee.toStringAsFixed(0)}',
                style: TextStyle(color: Color.fromARGB(255, 4, 51, 117))),
            Text('Promo: Rp ${promo.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.red)),
            const Divider(
                color:
                    Color.fromARGB(255, 4, 51, 117)), // Mengubah warna garis pemisah menjadi putih
            Text('Total Bayar: Rp ${totalPayment.toStringAsFixed(0)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color.fromARGB(255, 4, 51, 117))),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotifikasiPage(),
                    ),
                  );
                },
                child: Text(
                  'Lihat Riwayat Pemesanan',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

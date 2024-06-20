import 'package:flutter/material.dart';
import 'payment_page.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieTitle;
  final String imageUrl;

  SeatSelectionPage({required this.movieTitle, required this.imageUrl});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<String> selectedSeats = [];

  void _selectSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  Widget _buildSeatRow(String rowLabel) {
    List<Widget> seats = [];
    for (int i = 1; i <= 4; i++) {
      String seatNumber = '$rowLabel$i';
      bool isSelected = selectedSeats.contains(seatNumber);
      seats.add(_buildSeat(seatNumber, isSelected));
    }
    seats.add(const SizedBox(width: 16)); // Empty space in the middle
    for (int i = 5; i <= 9; i++) {
      String seatNumber = '$rowLabel$i';
      bool isSelected = selectedSeats.contains(seatNumber);
      seats.add(_buildSeat(seatNumber, isSelected));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: seats,
    );
  }

  Widget _buildSeat(String seatNumber, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectSeat(seatNumber),
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seatNumber,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = ['H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'];

    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
        title: const Text('Pilih Kursi'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Layar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 10,
            width: double.infinity,
            color: Color.fromARGB(255, 4, 51, 117),
          ),
          const SizedBox(height: 20), // Menambah jarak antara layar dan kursi
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return _buildSeatRow(rows[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5, // Menambahkan bayangan pada tombol
                shadowColor: Colors.grey.withOpacity(0.5),
              ),
              onPressed: selectedSeats.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            movieTitle: widget.movieTitle,
                            cinema: 'Pesona Square Premiere',
                            date: '14-04-2022',
                            time: '19:45',
                            studio: '1',
                            seats: selectedSeats,
                            ticketPrice: 30000,
                            admFee: 3000,
                            promo: 0,
                            totalPayment: (selectedSeats.length * 80000) + 3000,
                            imageUrl: widget.imageUrl,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                'Bayar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

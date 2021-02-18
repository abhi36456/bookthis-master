import 'package:bookthis/screens/booking/when.dart';
import 'package:bookthis/screens/booking/widgets/book_desk_card.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:flutter/material.dart';

class BookDesk extends StatefulWidget {
  @override
  _BookDeskState createState() => _BookDeskState();
}

class _BookDeskState extends State<BookDesk> {
  int _selected = -1;
  void selectDesk(i) {
    setState(() {
      _selected = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Desk",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookDeskCard(
            image: "shared_desk.png",
            title: "Shared Desk",
            onPressed: () {
              selectDesk(0);
            },
            selected: _selected == 0,
          ),
          SizedBox(
            height: 20,
          ),
          BookDeskCard(
            image: "personal_desk.png",
            title: "Personal Desk",
            onPressed: () {
              selectDesk(1);
            },
            selected: _selected == 1,
          ),
        ],
      ),
      actionButton: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selected == -1 ? null : next,
          child: Text("Next"),
        ),
      ),
    );
  }

  void next() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => When(
          details: {
            "type": "desk",
            "deskType": _selected == 0 ? "Shared" : "Personal",
          },
        ),
      ),
    );
  }
}

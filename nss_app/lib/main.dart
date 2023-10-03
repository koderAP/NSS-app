import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class EventData {
  final String eventName;
  final String eventDate;
  final int hoursAllotted;
  final bool isGround;

  EventData({
    required this.eventName,
    required this.eventDate,
    required this.hoursAllotted,
    required this.isGround,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NSS Flutter App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      builder: (context, child) {
        // MediaQuery
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: const MyHoursPage(title: 'Your Hours'),
    );
  }
}

final List<EventData> eventList = List.generate(
  10,
  (index) => EventData(
    eventName:
        'Event ${index + 1} is a very long event name that needs to wrap',
    eventDate: '01/01/YY',
    hoursAllotted: 1 + (index + 1) % 7,
    isGround: index.isEven,
  ),
);

class MyHoursPage extends StatelessWidget {
  const MyHoursPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const TotalHoursWidget(),
            const SizedBox(height: 20),
            const TotalCardsWidget(),
            const SizedBox(height: 20),
            const EventDataTableWidget(),
          ],
        ),
      ),
    );
  }
}

class TotalHoursWidget extends StatelessWidget {
  const TotalHoursWidget();

  final int max_hours = 80;

  @override
  Widget build(BuildContext context) {
    final int totalGroundHours = eventList
        .where((event) => event.isGround)
        .map((event) => event.hoursAllotted)
        .fold(0, (prev, curr) => prev + curr);

    final int totalNonGroundHours = eventList
        .where((event) => !event.isGround)
        .map((event) => event.hoursAllotted)
        .fold(0, (prev, curr) => prev + curr);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.3),
                    spreadRadius: 7,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircularProgressIndicator(
                value:
                    1 - ((totalGroundHours + totalNonGroundHours) / max_hours),
                strokeWidth: 25,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 186, 215, 233),
                ),
                backgroundColor: const Color.fromARGB(255, 51, 71, 144),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${totalGroundHours + totalNonGroundHours} hrs',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'completed',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TotalCardsWidget extends StatelessWidget {
  const TotalCardsWidget();

  @override
  Widget build(BuildContext context) {
    final int totalGroundHours = eventList
        .where((event) => event.isGround)
        .map((event) => event.hoursAllotted)
        .fold(0, (prev, curr) => prev + curr);

    final int totalNonGroundHours = eventList
        .where((event) => !event.isGround)
        .map((event) => event.hoursAllotted)
        .fold(0, (prev, curr) => prev + curr);

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CardWidget(
                    backgroundImage: 'assets/images/image1.png',
                    totalHours: totalGroundHours,
                    title: 'Total Ground Hours',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CardWidget(
                    backgroundImage: 'assets/images/image2.png',
                    totalHours: totalNonGroundHours,
                    title: 'Total Non-ground Hours',
                  ),
                ),
              ],
            ),
          ],
        ),
        
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width *
              0.165,
          right: MediaQuery.of(context).size.width *
              0.165, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/image1.png'),
                radius: 40,
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/image2.png'),
                radius: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String backgroundImage;
  final int totalHours;
  final String title;

  const CardWidget({
    required this.backgroundImage,
    required this.totalHours,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '$totalHours hrs',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '(Max 100 hrs)',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 6,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventDataTableWidget extends StatelessWidget {
  const EventDataTableWidget();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) {
          return const Color.fromARGB(255, 51, 71, 144);
        }),
        columnSpacing: 24.0,
        columns: const [
          DataColumn(
            label: Center(
              child: Text(
                'Event Name',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Event Date',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Hours Allotted',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        rows: eventList
            .map(
              (event) => DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 100, // Set a maximum width of 100 pixels
                      child: Center(
                        child: Text(
                          event.eventName,
                          textAlign: TextAlign.center,
                          maxLines: 2, // Allow text to wrap into two lines
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        event.eventDate,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        event.hoursAllotted.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

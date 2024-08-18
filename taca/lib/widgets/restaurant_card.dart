import 'package:flutter/material.dart';
import '../models/restaurants.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final void Function(Restaurant) onTap;

  RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey[900], // Dark background for the card
      elevation: 6,
      shadowColor: Colors.orangeAccent.withOpacity(0.7),
      child: InkWell(
        onTap: () => onTap(restaurant),
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [Colors.black87, Color.fromARGB(255, 10, 10, 10)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            title: Text(
              restaurant.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.type,
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                Text(
                  restaurant.place,
                  style: TextStyle(color: Colors.orangeAccent.withOpacity(0.8)),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < restaurant.rating ? Icons.star : Icons.star_border,
                      size: 18,
                      color: Colors.deepOrangeAccent,
                    );
                  }),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.orangeAccent,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

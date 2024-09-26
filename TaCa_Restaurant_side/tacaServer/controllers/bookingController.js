const mongoose = require('mongoose');
const Booking = require('../models/booking');
const Restaurant = require('../models/restaurant');
const User = require('../models/user');

exports.createBooking = async (req, res) => {
    try {
        const { userId, restaurantId, bookingDate, bookingTimeSlot, tableIds } = req.body;

        // Convert tableIds to ObjectIds
        const objectTableIds = tableIds.map(id => new mongoose.Types.ObjectId(id));

        console.log("Converted tableIds:", objectTableIds);  // Debug: Check converted tableIds

        if (!objectTableIds || objectTableIds.length === 0) {
            return res.status(400).json({ message: 'No table IDs provided.' });
        }

        // Check if any of the tables are already booked during the selected slot
        const existingBookings = await Booking.find({
            tableIds: { $in: objectTableIds },
            bookingDate,
            bookingTimeSlot
        });

        if (existingBookings.length > 0) {
            return res.status(400).json({ message: 'One or more tables are already booked for the selected time slot.' });
        }

        // Create a booking entry
        const newBooking = new Booking({
            userId,
            restaurantId,
            tableIds: objectTableIds,  // Ensure tableIds is saved correctly
            bookingDate,
            bookingTimeSlot
        });

        await newBooking.save();

        // Update the restaurant's table information
        await Promise.all(objectTableIds.map(async (tableId) => {
            await Restaurant.findOneAndUpdate(
                { _id: restaurantId, "tables._id": tableId },
                { 
                    $set: { 
                        "tables.$.bookingDetails": {
                            bookingId: newBooking._id,
                            bookedFrom: new Date(bookingDate + ' ' + bookingTimeSlot.split('-')[0]),
                            bookedTo: new Date(bookingDate + ' ' + bookingTimeSlot.split('-')[1]),
                        }
                    } 
                }
            );
        }));

        // Update user's and restaurant's bookings
        console.log("New booking ID:", newBooking._id);
        
        const user = await User.findById(userId);
console.log("User found:", user); // Debug: Check the booking ID

        await User.findByIdAndUpdate(
            userId, 
            { $push: { bookings: newBooking._id } },
            { new: true }  // Optionally return the updated document
        );
        console.log('hello')
        await Restaurant.findByIdAndUpdate(restaurantId, { $push: { bookings: newBooking._id } });
        console.log("jijijii")

        res.status(201).json({ booking: newBooking });
    } catch (err) {
        console.error('Error creating booking:', err.message);  // Debug: Check error message
        res.status(500).json({ error: err.message });
    }
};



exports.getBookingHistory = async (req, res) => {
    try {
      const { userId } = req.params;
  
      // Convert userId to ObjectId with 'new' keyword
      const bookings = await Booking.aggregate([
        { $match: { userId: new mongoose.Types.ObjectId(userId) } },  // Updated with 'new'
        {
          $lookup: {
            from: 'restaurants',
            localField: 'restaurantId',
            foreignField: '_id',
            as: 'restaurant'
          }
        },
        { $unwind: '$restaurant' }, // Unwind the restaurant array
        {
          $project: {
            restaurantName: '$restaurant.name',
            date: { $dateToString: { format: "%Y-%m-%d", date: "$bookingDate" } },
            time: '$bookingTimeSlot',
            tableIds: 1,
            restaurantTables: '$restaurant.tables'
          }
        },
        {
          $addFields: {
            filteredTables: {
              $filter: {
                input: '$restaurantTables',
                as: 'table',
                cond: { $in: ['$$table._id', '$tableIds'] }
              }
            }
          }
        },
        {
          $project: {
            restaurantName: 1,
            date: 1,
            time: 1,
            seats: {
              $map: {
                input: '$filteredTables',
                as: 'table',
                in: { tableNumber: '$$table.tableNumber', chairs: '$$table.chairs' }
              }
            }
          }
        }
      ]);
  
      res.status(200).json(bookings);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };


exports.getBookedTables = async (req, res) => {
    try {
        const { restaurantId, bookingDate, bookingTimeSlot } = req.query;
        const bookedTables = await Booking.find({
            restaurantId,
            bookingDate,
            bookingTimeSlot,
            status: 'booked'
        });

        res.status(200).json(bookedTables);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};


exports.getBookingsByRestaurantId = async (req, res) => {
    try {
      const { restaurantId } = req.params;
  
      // Convert the restaurantId to an ObjectId using 'new'
      const restaurantObjectId = new mongoose.Types.ObjectId(restaurantId);
  
      // Fetch bookings for the given restaurant
      const bookings = await Booking.find({ restaurantId: restaurantObjectId });
  
      const bookingDetails = await Promise.all(bookings.map(async (booking) => {
        const user = await User.findById(booking.userId);
        const restaurant = await Restaurant.findById(restaurantObjectId);
  
        const tableDetails = booking.tableIds.map(tableId => {
          const table = restaurant.tables.find(table => table._id.equals(tableId));
          return {
            tableNumber: table.tableNumber,
            chairs: table.chairs,
          };
        });
  
        return {
          userName: user.name,
          phone: user.phone,
          bookingDate: booking.bookingDate,
          bookingTimeSlot: booking.bookingTimeSlot,
          status: booking.status,
          tables: tableDetails,
        };
      }));
  
      res.status(200).json(bookingDetails);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
const Booking = require('../models/booking');
const Restaurant = require('../models/restaurant');
const User = require('../models/user');
const Review = require('../models/review');
const Menu = require('../models/menu');
const { default: mongoose } = require('mongoose');

// Get overview for a specific restaurant
exports.getRestaurantOverview = async (req, res) => {
    console.log(' this is the over view')
    const { id } = req.params;
    try {
        console.log(' this is the over view')
        const restaurant = await Restaurant.findById(id).populate('tables.bookingDetails.bookingId');
        
        const totalUsers = await User.countDocuments({ 'bookings': { $elemMatch: { $in: restaurant.tables.map(t => t.bookingDetails.bookingId) } } });
        const totalBookings = await Booking.countDocuments({ restaurantId: id });
        const totalReviews = await Review.countDocuments({ restaurantId: id });
        const totalMenus = await Menu.countDocuments({ resId: id });

        const overview = {
            name: restaurant.name,
            totalUsers,
            totalBookings,
            totalReviews,
            totalMenus
        };

        

        res.json(overview);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Get total users for a specific restaurant
exports.getTotalUsers = async (req, res) => {
    
    const { id } = req.params;
    console.log('jffdfdjfdjhfdj',id)
    try {
        const totalUsers = await Booking.aggregate([
            { 
                $match: { restaurantId: new mongoose.Types.ObjectId(id) } // Match the restaurantId with the provided id
            },
            { 
              $group: { _id: "$userId" } // Group by userId to get distinct userIds
            },
            { 
              $count: "totalUsers" // Count the number of distinct userIds
            }
          ]);

          console.log(totalUsers,'kakakak   ')
          
          // Extract the total count of users
          const totalUserCount = totalUsers.length > 0 ? totalUsers[0].totalUsers : 0;
          console.log(totalUserCount,'lalalal')
          
        res.json({ totalUserCount });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Get total bookings for a specific restaurant
exports.getTotalBookings = async (req, res) => {
    const { id } = req.params;
    try {
        
        const totalBookings = await Booking.countDocuments({ restaurantId: id });
        console.log('helljjj',totalBookings)
        res.json({ totalBookings });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Get total reviews for a specific restaurant
exports.getTotalReviews = async (req, res) => {
    const { id } = req.params;
    try {
        const totalReviews = await Review.countDocuments({ restaurantId: id });
        console.log(totalReviews,'kelloo')
        res.json({ totalReviews });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Get total menu items for a specific restaurant
exports.getTotalMenus = async (req, res) => {
    const { id } = req.params;
    try {
        const totalMenus = await Menu.countDocuments({ resId: id });
        console.log(totalMenus,'welloo')
        res.json({ totalMenus });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

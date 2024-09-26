const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

router.post('/create', bookingController.createBooking);
router.get('/history/:userId', bookingController.getBookingHistory);
router.get('/booked-tables', bookingController.getBookedTables);
router.get('/bookings/:restaurantId',bookingController.getBookingsByRestaurantId)
  
module.exports = router;

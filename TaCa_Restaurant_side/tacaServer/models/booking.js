const mongoose = require('mongoose');

const BookingSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    restaurantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Restaurant', required: true },
    tableIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Restaurant.tables', required: true }],

    bookingDate: { type: Date, required: true },
    bookingTimeSlot: { type: String, required: true }, // Can store as "HH:mm-HH:mm" or as two separate fields (startTime, endTime)
    createdAt: { type: Date, default: Date.now },
    status: { type: String, default: 'booked' },
});

module.exports = mongoose.model('Booking', BookingSchema);

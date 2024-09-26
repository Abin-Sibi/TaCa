const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt');

// Table Schema (Embedded within Restaurant)
const tableSchema = new Schema({
    tableNumber: { type: Number, required: true },
    chairs: { type: Number, required: true },
    position: {
        x: { type: Number, required: true, default: 0 },
        y: { type: Number, required: true, default: 0 }
    },
    bookingDetails: {
        bookingId: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking' },
        bookedFrom: { type: Date }, // Start time of booking
        bookedTo: { type: Date }    // End time of booking
    }
});

// Restaurant Schema
const restaurantSchema = new Schema({
    name: { type: String, required: true },
    place: { type: String, required: true },
    mobno: { type: String, required: true },
    emailid: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    type: { type: String, required: true },
    category: { type: String, required: true },
    geography: { type: String, required: true },
    tables: [tableSchema], // Embedding table schema
});

// Hash password before saving
restaurantSchema.pre('save', async function(next) {
    if (!this.isModified('password')) {
        return next();
    }
    try {
        const salt = await bcrypt.genSalt(10);
        this.password = await bcrypt.hash(this.password, salt);
        next();
    } catch (err) {
        next(err);
    }
});

module.exports = mongoose.model('Restaurant', restaurantSchema);

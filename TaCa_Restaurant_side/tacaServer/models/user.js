const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: {type:String,required:true},
    email: { type: String, unique: true },
    phone: {type: Number,required:true},
    password: {type:String,required:true},
    bookings: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Booking' }],
});

module.exports = mongoose.model('User', UserSchema);

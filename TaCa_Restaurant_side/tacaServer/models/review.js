// models/Review.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const reviewSchema = new Schema({
  userId: { type: String, required: true },
  restaurantId: { type: String, required: true },
  reviewText: { type: String, required: true },
  rating: { type: Number, required: true, min: 1, max: 5 },
  userName: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  badges: { type: Number, default: 0 },
  verified: { type: Number},
  location: {
    latitude: { type: Number },
    longitude: { type: Number },
    locationName: { type: String },
  },
});

module.exports = mongoose.model('Review', reviewSchema);

// models/FoodItem.js
const mongoose = require('mongoose');

const MenuSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  image: {
    type: String, // Store the image URL or Base64 string
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  resId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant', // Assuming you have a User model
    required: true,
  },
});

module.exports = mongoose.model('Menu', MenuSchema);

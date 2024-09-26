const Restaurant = require('../models/restaurant');

exports.getAllRestaurants = async (req, res) => {
    try {
        const restaurants = await Restaurant.find(); // Fetches all restaurants from the database
        res.status(200).json(restaurants);
    } catch (error) {
        console.error('Error fetching restaurants:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.getProfile = async (req,res)=>{
    
    try {
        const emailid = req.params.emailid;
        const restaurant = await Restaurant.findOne({ emailid });
    
        if (!restaurant) {
          return res.status(404).json({ message: 'Restaurant not found' });
        }
    
        res.json(restaurant);
      } catch (error) {
        console.error('Error fetching restaurant profile:', error);
        res.status(500).json({ message: 'Server error' });
      }
}

exports.updateProfile = async (req,res)=>{
    try {
        const emailid = req.params.emailid;
        const updateData = req.body;
    
        const updatedRestaurant = await Restaurant.findOneAndUpdate(
          { emailid },
          updateData,
          { new: true, runValidators: true }
        );
    
        if (!updatedRestaurant) {
          return res.status(404).json({ message: 'Restaurant not found' });
        }
    
        res.json(updatedRestaurant);
      } catch (error) {
        console.error('Error updating restaurant profile:', error);
        res.status(500).json({ message: 'Server error' });
      }
}

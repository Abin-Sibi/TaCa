const Restaurant = require('../models/restaurant');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.registerRestaurant = async (req, res) => {
    const { name, place, mobno, emailid, password, type, category, geography, tables } = req.body;

    try {
        // Check if the restaurant already exists
        const existingRestaurant = await Restaurant.findOne({ emailid });
        if (existingRestaurant) {
            return res.status(400).send('Restaurant already registered');
        }

        // Create a new restaurant with tables (password hashing is handled in the schema)
        const newRestaurant = new Restaurant({
            name,
            place,
            mobno,
            emailid,
            password, // plain password here, hashing will be done in the schema
            type,
            category,
            geography,
            tables // include the tables with their positions
        });

        await newRestaurant.save();
        res.status(200).send('Restaurant registered successfully');
    } catch (error) {
        res.status(400).send('Error registering restaurant: ' + error);
    }
};


exports.loginRestaurant = async (req, res) => {
    const { emailid, password } = req.body;
    console.log('Login Request Body:', req.body);

    try {
        const restaurant = await Restaurant.findOne({ emailid });

        if (!restaurant) {
            return res.status(400).send('Restaurant not found');
        }

        console.log('Stored Hashed Password during Login:', restaurant.password); // Log stored hashed password
        console.log('Entered Plain Password during Login:', password); // Log entered plain password

        // Compare the entered password with the stored hashed password
        const isMatch = await bcrypt.compare(password, restaurant.password);
        console.log('Password Match during Login:', isMatch); // Log password match result

        if (!isMatch) {
            return res.status(400).send('Invalid credentials');
        }
console.log('am abin');
        const payload = { user: { id: restaurant.id } };
        const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
        res.json({ token, restaurant });
    } catch (error) {
        res.status(500).send('Error logging in: ' + error);
    }
};

exports.getRestaurant= async (req, res) => {
    try {
      const { emailid } = req.params;
      const restaurant = await Restaurant.findOne({ emailid });
      
      if (!restaurant) {
        return res.status(404).json({ message: 'Restaurant not found' });
      }
      
      res.json(restaurant);
    } catch (error) {
      res.status(500).json({ message: 'Server error', error });
    }
  };

exports.addTables = async (req, res) => {
    const { restaurantId, tables } = req.body;

    try {
        const restaurant = await Restaurant.findById(restaurantId);
        if (!restaurant) {
            return res.status(404).send('Restaurant not found');
        }

        restaurant.tables = restaurant.tables.concat(tables);
        await restaurant.save();
        res.status(200).send('Tables added successfully');
    } catch (error) {
        res.status(400).send('Error adding tables: ' + error);
    }
};


// exports.updateTablePositions = async (req, res) => {
//     const { emailid, tables } = req.body;

//     try {
//         // Find the restaurant by email ID
//         const restaurant = await Restaurant.findOne({ emailid });
//         if (!restaurant) {
//             return res.status(404).send('Restaurant not found');
//         }

//         // Update table positions
//         tables.forEach(updatedTable => {
//             const table = restaurant.tables.find(t => t.tableNumber === updatedTable.tableNumber);
//             if (table) {
//                 table.position = updatedTable.position; // Update the position
//             }
//         });

//         await restaurant.save();
//         res.status(200).send('Table positions updated successfully');
//     } catch (error) {
//         res.status(400).send('Error updating table positions: ' + error);
//     }
// };

exports.updateTablePositions = async (req, res) => {
    console.log('here i am')
    const { id } = req.params; // The restaurant ID from the URL
    const { tables } = req.body; // The updated tables array from the request body
    
    try {
        
      // Find the restaurant by ID and update the tables
      const updatedRestaurant = await Restaurant.findByIdAndUpdate(
        id,
        { $set: { tables: tables } }, // Update the tables array
        { new: true } // Return the updated document
      );
  
      if (!updatedRestaurant) {
        
        return res.status(404).json({ message: 'Restaurant not found' });
      }
  
      res.status(200).json({ message: 'Table positions updated successfully', restaurant: updatedRestaurant });
    } catch (error) {
        
      console.error('Error updating table positions:', error);
      res.status(500).json({ message: 'Failed to update table positions', error });
    }
  };  
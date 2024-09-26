// routes/foodRoutes.js
const express = require('express');
const menuController = require('../controllers/menuController');
const router = express.Router();


// Fetch menu items for a specific restaurant
router.get('/menu/:resId', menuController.getMenu);

router.post('/add-food', menuController.createMenu);

// Edit a food item
router.put('/edit-food/:id', menuController.editMenu);

// Delete a food item
router.delete('/delete-food/:id', menuController.deleteMenu);

module.exports = router;

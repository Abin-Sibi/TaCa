const express = require('express');
const router = express.Router();
const userController = require('../controllers/userControllers');
const auth = require('../middleware/authMiddleware')

// Define your API routes
router.post('/register', userController.registerRestaurant);
router.post('/login', userController.loginRestaurant);
router.post('/add-tables',auth, userController.addTables);
router.get('/restaurant/:emailid',auth,userController.getRestaurant);
console.log('here i am12')
router.put('/restaurants/:id/tables',auth,userController.updateTablePositions);

module.exports = router;

const express = require('express');
const router = express.Router();
const { getAllRestaurants, getProfile, updateProfile } = require('../controllers/restaurantController');
const dashboardController = require('../controllers/dashboardController');

router.get('/restaurants', getAllRestaurants);
router.get('/restaurant/profile/:emailid',getProfile);
router.put('/restaurant/profile/:emailid',updateProfile);

router.get('/restaurant/overview/:id', dashboardController.getRestaurantOverview);
router.get('/restaurant/users/:id', dashboardController.getTotalUsers);
router.get('/restaurant/bookings/:id', dashboardController.getTotalBookings);
router.get('/restaurant/reviews/:id', dashboardController.getTotalReviews);
router.get('/restaurant/menus/:id', dashboardController.getTotalMenus);

module.exports = router;

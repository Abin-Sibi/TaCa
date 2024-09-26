// routes/reviewRoutes.js
const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');

router.post('/reviews', reviewController.postReview);
router.get('/reviews/:restaurantId', reviewController.getReviews);

module.exports = router;

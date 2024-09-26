const { spawn } = require('child_process');
const Review = require('../models/review');
const Restaurant = require('../models/restaurant'); // Assuming you have a Restaurant model

// Post a new review
exports.postReview = async (req, res) => {
  try {
    console.log("abcdefg")
    const { userId, restaurantId, reviewText, rating, userName, location,verified } = req.body;
console.log(req.body,'abdddd')
    // Save the review to the database
    const review = new Review({
      userId,
      restaurantId,
      reviewText,
      rating,
      userName,
      location,
      verified
    });

    await review.save();

    // Ensure the path to the Python script is correct
    const python = spawn('python', ['scripts/nlp_model.py', review.reviewText]);

    let pythonError = '';

    python.stdout.on('data', async (data) => {
      const classification = data.toString().trim(); 

      if (classification === 'good') {
        console.log('fjalsjjflakj');
        // Award badge logic
        const restaurant = await Review.findById(review._id);
        console.log(restaurant,'annnn');
        restaurant.badges += 1; // Increment badges
        await restaurant.save();
      }

      if (!res.headersSent) {
        res.status(201).json({ message: 'Review submitted and classified', classification });
      }
    });

    python.stderr.on('data', (data) => {
      pythonError += data.toString();
    });

    python.on('close', (code) => {
      if (code !== 0) {
        console.error(`Python script exited with code ${code}`);
        if (!res.headersSent) {
          res.status(500).json({ message: 'Error in Python script', error: pythonError });
        }
      }
    });

  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: 'Error posting review', error });
    }
  }
};
// Get all reviews for a particular restaurant
exports.getReviews = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const reviews = await Review.find({ restaurantId }).sort({ createdAt: -1 });
    res.status(200).json(reviews);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching reviews', error });
  }
};

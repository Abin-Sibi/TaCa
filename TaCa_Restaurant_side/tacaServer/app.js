const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
require('dotenv').config();
const menuRoutes = require('./routes/menuRoutes')
const restaurantRoutes = require('./routes/restaurantRoutes')
const reviewRoutes = require('./routes/reviewRoutes');
const bookingRoutes = require('./routes/bookingRoutes');
const authRoutes = require('./routes/authRoutes');


const app = express();

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(
    cors({
      origin: true, // Replace with your client URL
    })
  );
  
// Database connection
mongoose.connect('mongodb://127.0.0.1:27017/taca', {
    useNewUrlParser: true,   
    useUnifiedTopology: true,
  }).then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// API routes
const apiRoutes = require('./routes/api'); 

app.use('/api/auth', authRoutes);

app.use('/api', apiRoutes);
app.use('/api/food', menuRoutes);

app.use('/api', restaurantRoutes);
app.use('/api', reviewRoutes);
app.use('/api', bookingRoutes);
app.use('/',(req,res)=>{
  res.send('hello')
})


// Serve static files from React app
app.use(express.static(path.join(__dirname, '../client/build')));

// Handle React routing, return all requests to React app
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../client/build', 'index.html'));
});

const port = process.env.PORT || 5000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

  





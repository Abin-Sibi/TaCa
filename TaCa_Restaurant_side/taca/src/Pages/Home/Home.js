// Home.js
import React from 'react';
import './Home.css';

const Home = () => {
  return (
    <div className="about-container">
      <main className="main-content">
        <div className="main-text">
          <h1>The Castle</h1>
          <h2><span>Good</span> <span className="highlight">Taste</span> <span>is the</span> <span className="highlight">Enemy</span> <span>of</span> <span className="highlight">Creativity.</span></h2>
          <p>Welcome, where we believe that food is more than just sustenance - it's an experience. Our menu features a variety of dishes that are expertly prepared with fresh, locally sourced ingredients and served in a warm and inviting atmosphere.</p>
          <button className="menu-button">Today's Menu</button>
        </div>
        <div className="main-image">
          <img src="/Images/Res3.jpeg" alt="Restaurant" />
        </div>
      </main>
    </div>
  );
};

export default Home;

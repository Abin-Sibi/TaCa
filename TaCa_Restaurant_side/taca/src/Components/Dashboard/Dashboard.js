import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import axios from '../../axiosConfig';
import './Dashboard.css';
import CreateTableModal from '../CreateTableModal/CreateTableModal';
import RestaurantLayout from '../RestaurantLayout/RestaurantLayout';
import { Bar, Pie, Line } from 'react-chartjs-2'; // Import chart components
import { Chart, ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';

// Register necessary components
Chart.register(ArcElement, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);



const Dashboard = () => {
  const restaurant = useSelector((state) => state.restaurant.restaurant);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalBookings: 0,
    totalReviews: 0,
    totalMenuItems: 0,
    averageRating: 0,
  });

  const [users, setUsers] = useState(0)
  const [bookings, setBookings] = useState(0)
  const [reviews, setReviews] = useState(0)
  const [menus, setMenus] = useState(0)

  const openModal = () => {
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  useEffect(() => {
    // Fetch statistics data
    const fetchStats = async () => {
      try {
        const restaurantId = restaurant?._id;
        if (!restaurantId) return;

        console.log('hello',restaurant)

        const [usersResponse, bookingsResponse, reviewsResponse, menuResponse] = await Promise.all([
          axios.get(`/restaurant/users/${restaurantId}`), // Fetches total users
axios.get(`/restaurant/bookings/${restaurantId}`), // Fetches total bookings
axios.get(`/restaurant/reviews/${restaurantId}`), // Fetches total reviews
axios.get(`/restaurant/menus/${restaurantId}`), // Fetches total menus
        ]);

        console.log("ajdf",bookingsResponse.data)
        setUsers(usersResponse.data.totalUserCount)
        setBookings(bookingsResponse.data.totalBookings)
        setReviews(reviewsResponse.data.totalReviews)
        setMenus(menuResponse.data.totalMenus)

        setStats({
          totalUsers: usersResponse.data.totalUserCount,
          totalBookings: bookingsResponse.data,
          totalReviews: reviewsResponse.data.length,
          totalMenuItems: menuResponse.data.length,
          averageRating: reviewsResponse.data.reduce((acc, review) => acc + review.rating, 0) / reviewsResponse.data.length || 0
        });
      } catch (error) {
        console.error('Error fetching stats:', error);
      }
    };

    fetchStats();
  }, [restaurant]);

  // Data for the charts
  const salesData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'], // Replace with actual time data
    datasets: [
      {
        label: 'Sales',
        data: [1200, 1500, 1700, 2000, 1900, 2100], // Replace with actual sales data
        backgroundColor: '#42A5F5',
      },
    ],
  };

  const feedbackData = {
    labels: ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
    datasets: [
      {
        data: [5, 15, 25, 40, 15], // Replace with actual feedback count
        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#FF9F40', '#4BC0C0'],
      },
    ],
  };

  return (
    <>
      <div className="dashboard">
        <div className="dashboard-header">
          <h2>Dashboard</h2>
        </div>
        <h4 className='dname'>Welcome {restaurant?.name}</h4>
        <div className="dashboard-cards">
          <div className="dashboard-card">
            <h3>Total Users</h3>
            <p>{users}</p>
          </div>
          <div className="dashboard-card">
            <h3>Total Bookings</h3>
            <p>{bookings}</p>
          </div>
          <div className="dashboard-card">
            <h3>Total Reviews</h3>
            <p>{reviews}</p>
          </div>
          <div className="dashboard-card">
            <h3>Total Menu Items</h3>
            <p>{menus}</p>
          </div>
          <div className="dashboard-card">
            <h3>Average Rating</h3>
            <p>{restaurant?.rating}</p>
          </div>
        </div>
        <div className="dashboard-content">
          <div className="dashboard-section">
            <h3>Sales Overview</h3>
            <div className="graph-placeholder">
              <Line data={salesData} />
            </div>
          </div>
          <div className="dashboard-section">
            <h3>Customer Feedback</h3>
            <div className="graph-placeholder">
              <Pie data={feedbackData} />
            </div>
          </div>
          <div className="dashboard-section">
            <h3>Reservation Statistics</h3>
            <div className="graph-placeholder">
              {/* Implement a graph to show reservation data over time */}
            </div>
          </div>
        </div>
      </div>
      <div className="reslayout">
        <div className="table-create-btn">
          <h3>Create Tables</h3>
          
          <button className="create-table-button" onClick={openModal}>
            +
          </button>
        </div>
        <RestaurantLayout />
      </div>
      {isModalOpen && <CreateTableModal onClose={closeModal} />}

    </>
  );
};

export default Dashboard;

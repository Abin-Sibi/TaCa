
import React from 'react';
import { Routes, Route } from 'react-router-dom';
import './App.css';
import Footer from './Components/Footer/Footer';
import Register from './Pages/Register/Register';
import Home from './Pages/Home/Home';
import Login from './Pages/Login/Login';
import Modal from 'react-modal';
import DashboardPage from './Pages/ResDashPage/DashboardPage';
import Profile from './Pages/Profile/Profile';
import Header from './Components/Header/Header';
import MenuPage from './Components/Menu/MenuPage';
import BookingList from './Components/Bookings/BookingList';
import ReviewList from './Components/Reviews/ReviewList';
import { RestaurantProvider } from './RestaurantContext';



Modal.setAppElement('#root');
const App = () => {
  return (
    <div className="App">
      <RestaurantProvider>
        <Header/>
      <Routes>
      <Route path="/" element={<Home />} />
        <Route path="/home" element={<Home />} />
        <Route path="/register" element={<Register />} />
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<DashboardPage />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/menu" element={<MenuPage />} />
        <Route path="/reservations" element={<BookingList />} />
        <Route path="/reviews" element={<ReviewList />} />
      </Routes>
      <Footer />
      </RestaurantProvider>
      
    </div>
  );
};

export default App;


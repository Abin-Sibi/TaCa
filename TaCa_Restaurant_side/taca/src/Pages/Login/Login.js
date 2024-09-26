import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import axios from '../../axiosConfig';
import './Login.css';
import {setIsLoggedIn } from '../../redux/restaurantSlice';

const Login = () => {
  const [formData, setFormData] = useState({
    emailid: '',
    password: ''
  });

  const dispatch = useDispatch();
  const navigate = useNavigate();
  const isLoggedIn = useSelector((state) => state.restaurant.isLoggedIn);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token && !isLoggedIn) {
      dispatch(setIsLoggedIn(true));
      navigate('/dashboard');
    }
  }, [navigate, dispatch, isLoggedIn]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
  
    try {
      const response = await axios.post('/login', formData);
      if (response.status === 200) {
        const { token, restaurant } = response.data;
        localStorage.setItem('token', token);
        localStorage.setItem('emailid', restaurant.emailid); // Store emailid in localStorage
        // dispatch(setRestaurant(restaurant));
        dispatch(setIsLoggedIn(true));
        navigate('/dashboard');
      } else {
        alert('Invalid credentials');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('Error logging in');
    }
  };
  
  const handleRegisterClick = () => {
    navigate('/register');
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <h2>Login</h2>
        <form className="login-form" onSubmit={handleSubmit}>
          <label>Email ID</label>
          <input type="email" name="emailid" value={formData.emailid} onChange={handleChange} required />

          <label>Password</label>
          <input type="password" name="password" value={formData.password} onChange={handleChange} required />

          <button type="submit">Login</button>
          <div className="register-link">
            Don't have an account? <button type="button" onClick={handleRegisterClick} className="link-button">Register</button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Login;

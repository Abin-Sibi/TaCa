import React, { useState } from 'react';
import './Register.css';
import axios from '../../axiosConfig';

const Register = () => {
  const [formData, setFormData] = useState({
    name: '',
    place: '',
    mobno: '',
    emailid: '',
    password: '',
    confirmPassword: '',
    type: '',
    category: '',
    geography: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (formData.password !== formData.confirmPassword) {
      alert('Passwords do not match');
      return;
    }

    try {
      const response = await axios.post('/register', formData);
      if (response.status === 200) {
        alert('Restaurant registered successfully');
      } else {
        alert('Error registering restaurant: ' + response.data.message);
      }
    } catch (error) {
      console.error('Error:', error);
      alert('Error registering restaurant');
    }
  };

  return (
    <div className='container'>
      <div className="register-container">
        <h2>Register Your Restaurant</h2>
        <form className="register-form" onSubmit={handleSubmit}>
          <label>Name</label>
          <input type="text" name="name" value={formData.name} onChange={handleChange} required />

          <label>Place</label>
          <input type="text" name="place" value={formData.place} onChange={handleChange} required />

          <label>Mobile Number</label>
          <input type="text" name="mobno" value={formData.mobno} onChange={handleChange} required />

          <label>Email ID</label>
          <input type="email" name="emailid" value={formData.emailid} onChange={handleChange} required />

          <label>Password</label>
          <input type="password" name="password" value={formData.password} onChange={handleChange} required />

          <label>Confirm Password</label>
          <input type="password" name="confirmPassword" value={formData.confirmPassword} onChange={handleChange} required />

          <label>Type</label>
          <select name="type" value={formData.type} onChange={handleChange} required>
            <option value="">Select Cuisine Type</option>
            <option value="Chinese">Chinese</option>
            <option value="Arabian">Arabian</option>
            <option value="Italian">Italian</option>
            <option value="Indian">Indian</option>
            <option value="Mexican">Mexican</option>
          </select>

          <label>Category</label>
          <select name="category" value={formData.category} onChange={handleChange} required>
            <option value="">Select Category</option>
            <option value="Veg">Veg</option>
            <option value="Mixed">Mixed</option>
          </select>

          <label>Geography</label>
          <select name="geography" value={formData.geography} onChange={handleChange} required>
            <option value="">Select Geography</option>
            <option value="Hill-View">Hill-View</option>
            <option value="Beach-Side">Beach-Side</option>
            <option value="City-Center">City Center</option>
          </select>

          <button type="submit">Register</button>
        </form>
      </div>
    </div>
  );
};

export default Register;

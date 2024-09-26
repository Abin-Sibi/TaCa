import React, { useState, useEffect } from 'react';
import axios from '../../axiosConfig'; // Import axios with custom configuration
import './Profile.css';

const Profile = () => {
  const [profileData, setProfileData] = useState({
    name: '',
    place: '',
    mobno: '',
    emailid: '', // This will be read-only
    type: '',
    category: '',
    geography: '',
    aboutMe: '', // Assuming you want to keep this field
  });

  useEffect(() => {
    // Fetch the restaurant data when the component mounts
    const fetchProfileData = async () => {
      try {
        const emailid = localStorage.getItem('emailid');
        const response = await axios.get(`/restaurant/profile/${emailid}`, {
          headers: { 'x-auth-token': localStorage.getItem('token') },
        });
        setProfileData(response.data); // Set the fetched data to state
      } catch (error) {
        console.error('Error fetching profile data:', error);
      }
    };

    fetchProfileData();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setProfileData({ ...profileData, [name]: value });
  };

  const handleUpdate = async () => {
    try {
      const emailId = localStorage.getItem('emailid');
      const { password, emailid, ...updateData } = profileData; // Exclude password and emailid
      const response = await axios.put(`/restaurant/profile/${emailId}`, updateData, {
        headers: { 'x-auth-token': localStorage.getItem('token') },
      });

      if (response.status === 200) {
        alert('Profile updated successfully!');
      }
    } catch (error) {
      console.error('Error updating profile:', error);
      alert('Error updating profile.');
    }
  };

  return (
    <div className="profile-container">
      <div className="profile-sidebar">
        <h2>PROFILE</h2>
        <div className="profile-pic">
          <img src="/images/Res1.jpeg" alt="Avatar" />
          <button className="upload-button">Upload Picture</button>
        </div>
        {/* Display restaurant details neatly */}
        <div className="restaurant-details">
          <h3>Restaurant Details</h3>
          <p><strong>Name:</strong> {profileData.name}</p>
          <p><strong>Place:</strong> {profileData.place}</p>
          <p><strong>Mobile Number:</strong> {profileData.mobno}</p>
          <p><strong>E-mail:</strong> {profileData.emailid}</p>
          <p><strong>Type:</strong> {profileData.type}</p>
          <p><strong>Category:</strong> {profileData.category}</p>
          <p><strong>Geography:</strong> {profileData.geography}</p>
        </div>
      </div>
      <div className="profile-main">
        <h3 className='proup'>Update Restaurant Information</h3>
        <div className="profile-form">
          <div className="form-group">
            <label>Name:</label>
            <input type="text" name="name" value={profileData.name} onChange={handleChange} />
          </div>
          <div className="form-group">
            <label>Place:</label>
            <input type="text" name="place" value={profileData.place} onChange={handleChange} />
          </div>
          <div className="form-group">
            <label>Mobile Number:</label>
            <input type="text" name="mobno" value={profileData.mobno} onChange={handleChange} />
          </div>
          <div className="form-group">
            <label>E-mail:</label>
            <input type="email" name="emailid" value={profileData.emailid} readOnly />
          </div>
          <div className="form-group">
            <label>Type:</label>
            <input type="text" name="type" value={profileData.type} onChange={handleChange} />
          </div>
          <div className="form-group">
            <label>Category:</label>
            <input type="text" name="category" value={profileData.category} onChange={handleChange} />
          </div>
          <div className="form-group">
            <label>Geography:</label>
            <input type="text" name="geography" value={profileData.geography} onChange={handleChange} />
          </div>
          <button className="update-button" onClick={handleUpdate}>Update Information</button>
        </div>
      </div>
    </div>
  );
};

export default Profile;

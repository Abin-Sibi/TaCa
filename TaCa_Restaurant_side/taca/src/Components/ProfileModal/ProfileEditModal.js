import React, { useState } from 'react';
import Modal from 'react-modal';
import './ProfileEditModal.css';

const ProfileEditModal = ({ isOpen, onRequestClose }) => {
    console.log("hello")
//   const [formData, setFormData] = useState(profileData);

  const handleChange = (e) => {
    const { name, value } = e.target;
    // setFormData({
    //   ...formData,
    //   [name]: value,
    // });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onloadend = () => {
    //   setFormData({
    //     // ...formData,
    //     profileImage: reader.result,
    //   });
    };
    reader.readAsDataURL(file);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // onSave(formData);
    onRequestClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onRequestClose={onRequestClose}
      contentLabel="Edit Profile"
      className="Modal"
      overlayClassName="Overlay"
    >
      <h2>Edit Profile</h2>
      <form onSubmit={handleSubmit} className="profile-edit-form">
        <label>Profile Image</label>
        <input type="file" name="profileImage" onChange={handleImageChange} />

        <label>Name</label>
        <input type="text" name="name"  onChange={handleChange} required />

        <label>Description</label>
        <textarea name="description"  onChange={handleChange} required />

        <label>Place</label>
        <input type="text" name="place"  onChange={handleChange} required />

        <label>Mobile Number</label>
        <input type="text" name="mobno"  onChange={handleChange} required />

        <label>Email ID</label>
        <input type="email" name="emailid"  onChange={handleChange} required />

        <label>Type</label>
        <select name="type"  onChange={handleChange} required>
          <option value="">Select Cuisine Type</option>
          <option value="Chinese">Chinese</option>
          <option value="Arabian">Arabian</option>
          <option value="Italian">Italian</option>
          <option value="Indian">Indian</option>
          <option value="Mexican">Mexican</option>
        </select>

        <label>Category</label>
        <select name="category"  onChange={handleChange} required>
          <option value="">Select Category</option>
          <option value="Veg">Veg</option>
          <option value="Mixed">Mixed</option>
        </select>

        <label>Geography</label>
        <select name="geography"  onChange={handleChange} required>
          <option value="">Select Geography</option>
          <option value="Hill-View">Hill-View</option>
          <option value="Beach-Side">Beach-Side</option>
          <option value="City-Center">City Center</option>
        </select>

        <button type="submit">Save</button>
        <button type="button" onClick={onRequestClose}>Cancel</button>
      </form>
    </Modal>
  );
};

export default ProfileEditModal;

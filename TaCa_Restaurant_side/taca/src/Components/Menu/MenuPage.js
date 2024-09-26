import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import Modal from 'react-modal';
import axios from '../../axiosConfig';
import './MenuPage.css';

Modal.setAppElement('#root');

const MenuPage = () => {
  const restaurant = useSelector((state) => state.restaurant.restaurant);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [foodItems, setFoodItems] = useState([]);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    image: '',
    price: '',
  });
  const [imagePreview, setImagePreview] = useState(null);
  const [editMode, setEditMode] = useState(false);
  const [editItemId, setEditItemId] = useState(null);

  useEffect(() => {
    const fetchMenuData = async () => {
      try {
        const response = await axios.get(`/food/menu/${restaurant._id}`);
        setFoodItems(response.data);
      } catch (error) {
        console.error('Failed to fetch menu data:', error);
      }
    };

    fetchMenuData();
  }, [restaurant._id,editMode]);

  const openModal = () => {
    setIsModalOpen(true);
    setImagePreview(null); // Reset image preview when opening the modal
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setEditMode(false);
    setFormData({
      name: '',
      description: '',
      image: '',
      price: '',
    });
    setImagePreview(null);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onloadend = () => {
      setFormData({
        ...formData,
        image: reader.result,
      });
      setImagePreview(reader.result); // Set image preview
    };
    if (file) {
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
  
    const menuData = {
      ...formData,
      resId: restaurant._id,
    };
  
    if (editMode) {
      // Update food item if in edit mode
      axios.put(`/food/edit-food/${editItemId}`, menuData)
        .then(response => {
          console.log(response.data)
          // setFoodItems(
          //   foodItems.map(item =>
          //     item._id === editItemId ? { ...item, ...menuData } : item
          //   )
          // );
          closeModal();
        })
        .catch(error => {
          console.error('Failed to update food item:', error);
        });
    } else {
      // Add new food item
      axios.post('/food/add-food', menuData)
        .then(response => {
          setFoodItems([...foodItems, response.data]);
          closeModal();
        })
        .catch(error => {
          console.error('Failed to add food item:', error);
        });
    }
  };
  
  const handleEdit = (index) => {
    const item = foodItems[index];
    setFormData(item);
    setImagePreview(item.image); // Set the current image as the preview
    setEditMode(true);
    setEditItemId(item._id);
    setIsModalOpen(true);
  };

  const handleDelete = async (index) => {
    const itemToDelete = foodItems[index];
    try {
      await axios.delete(`/food/delete-food/${itemToDelete._id}`);
      setFoodItems(foodItems.filter((_, i) => i !== index));
    } catch (error) {
      console.error('Failed to delete food item:', error);
    }
  };

  return (
    <div className="menu-page">
      <h1 className="menu-title">Menu</h1>
      <div className="food-grid">
        {foodItems.map((item, index) => (
          <div className="food-card" key={index}>
            <div className="food-details">
              {item.image && <img src={item.image} alt={item.name} />}
              <div>
                <h3>{item.name}</h3>
                <p>{item.description}</p>
                <p>${item.price}</p>
              </div>
            </div>
            <div className="food-actions">
              <button onClick={() => handleEdit(index)}>Edit</button>
              <button onClick={() => handleDelete(index)}>Delete</button>
            </div>
          </div>
        ))}
      </div>
      <button className="add-food-button" onClick={openModal}>+</button>

      <Modal
        isOpen={isModalOpen}
        onRequestClose={closeModal}
        contentLabel={editMode ? 'Edit Food Item' : 'Add Food Item'}
        className="Modal"
        overlayClassName="Overlay"
      >
        <h2>{editMode ? 'Edit Food Item' : 'Add Food Item'}</h2>
        <form onSubmit={handleSubmit} className="food-form">
          <label>Name</label>
          <input
            type="text"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
          />

          <label>Description</label>
          <textarea
            name="description"
            value={formData.description}
            onChange={handleChange}
            required
          />

          <label>Image</label>
          <input type="file" name="image" onChange={handleImageChange} />
          {imagePreview && (
            <div className="image-preview">
              <img className="preview-image"  src={imagePreview} alt="Preview" />
            </div>
          )}

          <label>Price</label>
          <input
            type="number"
            name="price"
            value={formData.price}
            onChange={handleChange}
            required
          />

          <div className="button-group">
            <button type="submit">Save</button>
            <button type="button" onClick={closeModal}>
              Cancel
            </button>
          </div>
        </form>
      </Modal>
    </div>
  );
};

export default MenuPage;

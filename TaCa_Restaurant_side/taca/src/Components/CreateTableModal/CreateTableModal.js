import React, { useState } from 'react';
import axios from '../../axiosConfig';
import './CreateTableModal.css';
import { useDispatch, useSelector } from 'react-redux';
import { setRestaurant } from '../../redux/restaurantSlice';

const CreateTableModal = ({ onClose }) => {
  const [tables, setTables] = useState([{ tableNumber: '', chairs: '' }]);
  const restaurant = useSelector((state) => state.restaurant.restaurant);
  const dispatch = useDispatch();

  const handleAddRow = () => {
    setTables([...tables, { tableNumber: '', chairs: '' }]);
  };

  const handleRemoveRow = (index) => {
    const newTables = [...tables];
    newTables.splice(index, 1);
    setTables(newTables);
  };

  const handleChange = (index, event) => {
    const { name, value } = event.target;
    const newTables = [...tables];
    newTables[index][name] = value;
    setTables(newTables);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    try {
      const response = await axios.post(
        '/add-tables',
        {
          restaurantId: restaurant._id,
          tables,
        },
        {
          headers: { 'x-auth-token': localStorage.getItem('token') },
        }
      );
      if (response.status === 200) {
        alert('Tables created successfully');

        // Fetch the updated restaurant data
        const updatedRestaurantResponse = await axios.get(
          `/restaurant/${restaurant.emailid}`,
          {
            headers: { 'x-auth-token': localStorage.getItem('token') },
          }
        );
        dispatch(setRestaurant(updatedRestaurantResponse.data)); // Update Redux store with new data

        onClose(); // Close the modal
      }
    } catch (error) {
      console.error('Error creating tables:', error);
      alert('Error creating tables');
    }
  };

  return (
    <div className="modal">
      <div className="modal-content">
        <span className="close" onClick={onClose}>&times;</span>
        <h2>Create Table</h2>
        <form onSubmit={handleSubmit}>
          {tables.map((table, index) => (
            <div className="form-row" key={index}>
              <input
                type="text"
                name="tableNumber"
                placeholder="Table Number"
                value={table.tableNumber}
                onChange={(event) => handleChange(index, event)}
                required
              />
              <input
                type="text"
                name="chairs"
                placeholder="Number of Chairs"
                value={table.chairs}
                onChange={(event) => handleChange(index, event)}
                required
              />
              {tables.length > 1 && (
                <button
                  type="button"
                  className="add-button"
                  onClick={() => handleRemoveRow(index)}
                >
                  -
                </button>
              )}
              {index === tables.length - 1 && (
                <button
                  type="button"
                  className="add-button"
                  onClick={handleAddRow}
                >
                  +
                </button>
              )}
            </div>
          ))}
          <button type="submit" className="submit-button">Submit</button>
        </form>
      </div>
    </div>
  );
};

export default CreateTableModal;

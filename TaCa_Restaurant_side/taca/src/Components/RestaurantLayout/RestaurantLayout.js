import React, { useState } from 'react';
import './RestaurantLayout.css';
import { useSelector, useDispatch } from 'react-redux';
import axios from '../../axiosConfig';

const RestaurantLayout = () => {
  const restaurant = useSelector((state) => state.restaurant.restaurant);
  const [positions, setPositions] = useState({});
  const dispatch = useDispatch();

  if (!restaurant || !restaurant.tables) {
    return <div>Loading...</div>;
  }

  const handleMouseDown = (e, tableNumber) => {
    const tablePos = positions[tableNumber] || restaurant.tables.find(table => table.tableNumber === tableNumber).position;
    const startX = e.clientX - tablePos.x;
    const startY = e.clientY - tablePos.y;
  
    const container = document.querySelector('.restaurant-layout');
    const containerRect = container.getBoundingClientRect();
  
    const mouseMoveHandler = (moveEvent) => {
      let newX = moveEvent.clientX - startX;
      let newY = moveEvent.clientY - startY;
  
      // Restrict the newX and newY within the container's bounds
      const tableWidth = 100; // Assuming table width is 100px
      const tableHeight = 100; // Assuming table height is 100px
  
      // Ensure the table does not go out of bounds on the left or right
      if (newX < 0) newX = 0;
      if (newX + tableWidth > containerRect.width) newX = containerRect.width - tableWidth;
  
      // Ensure the table does not go out of bounds on the top or bottom
      if (newY < 0) newY = 0;
      if (newY + tableHeight > containerRect.height) newY = containerRect.height - tableHeight;
  
      setPositions((prevPositions) => ({
        ...prevPositions,
        [tableNumber]: { x: newX, y: newY },
      }));
    };
  
    const mouseUpHandler = () => {
      document.removeEventListener('mousemove', mouseMoveHandler);
      document.removeEventListener('mouseup', mouseUpHandler);
    };
  
    document.addEventListener('mousemove', mouseMoveHandler);
    document.addEventListener('mouseup', mouseUpHandler);
  };
  

  const savePositions = async () => {
    try {
      const updatedTables = restaurant.tables.map((table) => ({
        ...table,
        position: positions[table.tableNumber] || table.position,
      }));

      await axios.put(`/restaurants/${restaurant._id}/tables`, { tables: updatedTables },{
        headers: { 'x-auth-token': localStorage.getItem('token')} 
      });

      dispatch({ type: 'UPDATE_TABLE_POSITIONS', payload: updatedTables });
      alert('Table positions updated successfully!');
    } catch (error) {
      console.error('Error saving table positions:', error);
      alert('Failed to save table positions. Please try again.');
    }
  };

  const renderChairs = (chairs) => {
    const positions = {
      2: ['top-middle', 'bottom-middle'],
      4: ['top-left', 'top-right', 'bottom-left', 'bottom-right'],
      6: [
        'top-left', 'top-right', 'bottom-left', 'bottom-right',
        'middle-left', 'middle-right'
      ],
      8: [
        'top-left', 'top-right', 'bottom-left', 'bottom-right',
        'middle-left', 'middle-right', 'top-middle', 'bottom-middle'
      ]
    };

    if (!positions[chairs]) {
      return [];
    }

    return positions[chairs].map((pos, index) => (
      <div key={index} className={`chair ${pos}`}></div>
    ));
  };

  return (
    <div className="restaurant-layout">
      <div className="tables-container">
        {restaurant.tables.map((table) => {
          const { x = 0, y = 0 } = positions[table.tableNumber] || table.position;
          let tableClass = 'table-rectangular';
          if (table.chairs === 3) tableClass = 'table-square';
          if (table.chairs === 4) tableClass = 'table-square2';
          if (table.chairs === 5) tableClass = 'table-square2';
          if (table.chairs === 6) tableClass = 'table-square3';
          if (table.chairs === 7) tableClass = 'table-large-rectangular1';
          if (table.chairs === 8) tableClass = 'table-large-rectangular2';
          if (table.chairs === 9) tableClass = 'table-large-rectangular3';
          if (table.chairs > 9) tableClass = 'table-large-rectangular';

          return (
            <div
              key={table.tableNumber}
              className={`table ${tableClass}`}
              style={{ transform: `translate(${x}px, ${y}px)` }}
              onMouseDown={(e) => handleMouseDown(e, table.tableNumber)}
            >
              <div className="table-name">{table.tableNumber}</div>
              <div className="chairs">
                {renderChairs(table.chairs)}
              </div>
            </div>
          );
        })}
      </div>
      <button onClick={savePositions} className="save-button">Save Layout</button>
    </div>
  );
};

export default RestaurantLayout;

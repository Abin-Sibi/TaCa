import React, { useState } from 'react';
import './BookingCard.css';

const BookingCard = ({ reservation }) => {
  const [isExpanded, setIsExpanded] = useState(false);

  const toggleCard = () => {
    setIsExpanded(!isExpanded);
  };

  return (
    <div className="booking-card" onClick={toggleCard}>
      <div className="card-header">
        <div className="avatar">
          {reservation.userName.charAt(0)}
        </div>
        <div className="customer-info">
          <h3>{reservation.userName}</h3>
          {reservation.phone && (
            <div className="contact-info">
              <i className="fa fa-phone" aria-hidden="true"></i> {reservation.phone}
            </div>
          )}
        </div>
        <div className={`status ${reservation.status}`}>
          {reservation.status}
        </div>
      </div>
      <div className={`card-body ${isExpanded ? 'show' : ''}`}>
        <div className="booking-details">
          <p><strong>Date:</strong> {new Date(reservation.bookingDate).toLocaleDateString()}</p>
          <p><strong>Time Slot:</strong> {reservation.bookingTimeSlot}</p>
          <p><strong>Tables:</strong></p>
          <ul className="table-list">
            {reservation.tables.map((table, index) => (
              <li key={index}>Table {table.tableNumber} ({table.chairs} chairs)</li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default BookingCard;

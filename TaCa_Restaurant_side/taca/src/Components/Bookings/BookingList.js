import React, { useEffect, useState } from 'react';
import './BookingCard.css';
import BookingCard from './BookingCard';
import axios from '../../axiosConfig';
import { useSelector } from 'react-redux';

const BookingList = () => {
  const [reservations, setReservations] = useState([]);
  const [filteredReservations, setFilteredReservations] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const restaurant = useSelector((state) => state.restaurant.restaurant);

  useEffect(() => {
    const fetchReservations = async () => {
      try {
        const response = await axios.get(`/bookings/${restaurant._id}`); // Replace with your actual API endpoint
        setReservations(response.data);
        setFilteredReservations(response.data); // Initially set filtered reservations to all reservations
        setLoading(false);
      } catch (error) {
        console.error('Error fetching reservation data:', error);
        setLoading(false);
      }
    };

    fetchReservations();
  }, [restaurant._id]);

  const handleSearchChange = (e) => {
    const query = e.target.value.toLowerCase();
    setSearchQuery(query);

    // Filter reservations based on the search query
    const filtered = reservations.filter((reservation) =>
      reservation.userName.toLowerCase().includes(query)
    );
    setFilteredReservations(filtered);
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="booking-list-container">
      <h2 className="heading">Reservations</h2>
      <input
        type="text"
        className="search-input"
        placeholder="Search by customer name"
        value={searchQuery}
        onChange={handleSearchChange}
      />
      <div className="booking-list">
        {filteredReservations.map((reservation, index) => (
          <BookingCard key={index} reservation={reservation} />
        ))}
      </div>
    </div>
  );
};

export default BookingList;

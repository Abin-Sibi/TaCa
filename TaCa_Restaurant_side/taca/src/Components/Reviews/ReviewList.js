import React, { useEffect, useState } from 'react';
import ReviewCard from './ReviewCard';
import './ReviewList.css';
import { useSelector } from 'react-redux';
import axios from '../../axiosConfig';

const ReviewList = () => {
    const restaurant = useSelector((state) => state.restaurant.restaurant);
    const [reviews, setReviews] = useState([]);

    useEffect(() => {
        const fetchReviews = async () => {
            try {
                const response = await axios.get(`/reviews/${restaurant._id}`);
                setReviews(response.data);

                console.log(response.data,"hihihiih")
            } catch (error) {
                console.error('Error fetching reviews:', error);
            }
        };

        fetchReviews();
    }, [restaurant]);

    const averageRating = reviews.reduce((acc, review) => acc + review.rating, 0) / reviews.length || 0;

    console.log(averageRating,'hiiiiii')

    const renderStars = (rating) => {
        const fullStars = Math.ceil(rating);
        // const halfStars = rating - fullStars >= 0.5 ? 1 : 0;
        const emptyStars = 5 - fullStars;

        console.log('klllll',emptyStars,'looooo',fullStars)
        return (
            <div className="average-rating">
                {'★'.repeat(fullStars)}
                {'☆'.repeat(emptyStars)}
            </div>
        );
    };

    return (
        <div className="review-list-container">
            <h2 className="heading">We Care About Our Customers' Experience Too</h2>
            <div className="average-feedback">
                {renderStars(averageRating)}
            </div>
            <div className="review-list">
                {reviews.map((review, index) => (
                    <ReviewCard key={index} review={review} />
                ))}
            </div>
        </div>
    );
};

export default ReviewList;

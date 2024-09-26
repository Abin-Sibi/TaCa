import React from 'react';
import './ReviewCard.css';

const ReviewCard = ({ review }) => {
    return (
        <div className="review-card">
            <div className="card-header">
                <div className="avatar">
                    {review.userName.charAt(0)}
                </div>
                <div className="review-info">
                    <h3>{review.userName}</h3>
                    <p>{review.reviewText}</p>
                    <div className="rating">
                        {'★'.repeat(review.rating)}
                        {'☆'.repeat(5 - review.rating)}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ReviewCard;

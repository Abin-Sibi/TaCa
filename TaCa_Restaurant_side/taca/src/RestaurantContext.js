import React, { createContext, useState } from 'react';

export const RestaurantContext = createContext();

export const RestaurantProvider = ({ children }) => {
  const [restaurant, setRestaurant] = useState(null);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  return (
    <RestaurantContext.Provider value={{ restaurant, setRestaurant, isLoggedIn, setIsLoggedIn }}>
      {children}
    </RestaurantContext.Provider>
  );
};

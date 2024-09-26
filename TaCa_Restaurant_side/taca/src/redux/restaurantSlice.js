import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  restaurant: null,
  isLoggedIn: false,
};

const restaurantSlice = createSlice({
  name: 'restaurant',
  initialState,
  reducers: {
    setRestaurant: (state, action) => {
      state.restaurant = action.payload;
    },
    setIsLoggedIn: (state, action) => {
      state.isLoggedIn = action.payload;
    },
    updateTablePositions: (state, action) => {
      if (state.restaurant && state.restaurant.tables) {
        state.restaurant.tables = state.restaurant.tables.map((table) => {
          const updatedTable = action.payload.find(t => t.tableNumber === table.tableNumber);
          return updatedTable ? { ...table, position: updatedTable.position } : table;
        });
      }
    },
    logout: (state) => {
      state.restaurant = null;
      state.isLoggedIn = false;
      localStorage.removeItem('token');
    },
  },
});

export const { setRestaurant, setIsLoggedIn, updateTablePositions, logout } = restaurantSlice.actions;

export default restaurantSlice.reducer;

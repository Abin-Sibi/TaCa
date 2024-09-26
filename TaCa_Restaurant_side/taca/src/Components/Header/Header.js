import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import axios from '../../axiosConfig'; // Ensure the correct path
import { logout, setRestaurant } from '../../redux/restaurantSlice';
import './Header.css';

const Header = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const [activeLink, setActiveLink] = useState('home');
  const [isVisible, setIsVisible] = useState(true);
  const [lastScrollY, setLastScrollY] = useState(0);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const token = localStorage.getItem('token');
  const emailid = localStorage.getItem('emailid')
  // const emailid = useSelector((state) => state.restaurant.restaurant?.emailid);

  const fetchRestaurantData = async () => {
    try {
      if (emailid) {
        const response = await axios.get(`/restaurant/${emailid}`,{
          headers: { 'x-auth-token': localStorage.getItem('token')} 
        });
        console.log(response, "Fetched restaurant data");
        dispatch(setRestaurant(response.data)); // Store the fetched data in Redux
      }
    } catch (error) {
      console.error('Error fetching restaurant data:', error);
    }
  };

  useEffect(() => {
    if (token) {
      fetchRestaurantData();
    } else {
      dispatch(logout()); // Ensure Redux state is cleared if no token
      navigate('/login'); // Redirect to login if no token
    }
  }, [token, emailid, dispatch]);

  const handleLinkClick = (link) => {
    setActiveLink(link);
    setIsMenuOpen(false);
    navigate(`/${link}`);
  };

  const controlHeader = useCallback(() => {
    if (window.scrollY > lastScrollY) {
      setIsVisible(false);
    } else {
      setIsVisible(true);
    }
    setLastScrollY(window.scrollY);
  }, [lastScrollY]);

  useEffect(() => {
    window.addEventListener('scroll', controlHeader);

    return () => {
      window.removeEventListener('scroll', controlHeader);
    };
  }, [controlHeader]);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    dispatch(logout());
    navigate('/login');
  };

  return (
    <header className={`header ${isVisible ? 'visible' : 'hidden'} ${isMenuOpen ? 'menu-open' : ''}`}>
      <div className="logo" onClick={() => handleLinkClick('home')}>
        <img src="/images/chef-hat.png" alt="TaCa" />
        <span>TaCa</span>
      </div>
      <nav className={`nav ${isMenuOpen ? 'open' : ''}`}>
        <ul>
          {['home', 'profile', 'menu', 'reservations', 'reviews'].map((link) => (
            <li key={link}>
              <button
                className={`nav-link ${activeLink === link ? 'active' : ''}`}
                onClick={() => handleLinkClick(link)}
              >
                {link.charAt(0).toUpperCase() + link.slice(1)}
              </button>
            </li>
          ))}
          {isMenuOpen && (
            <>
              {!token ? (
                <>
                  <li>
                    <button className="nav-link" onClick={() => handleLinkClick('register')}>New Registration</button>
                  </li>
                  <li>
                    <button className="nav-link" onClick={() => handleLinkClick('login')}>Login</button>
                  </li>
                </>
              ) : (
                <li>
                  <button className="nav-link" onClick={handleLogout}>Logout</button>
                </li>
              )}
            </>
          )}
        </ul>
      </nav>
      <div className="button-group">
        {!token ? (
          <>
            <button className="book-button" onClick={() => handleLinkClick('register')}>New Registration</button>
            <button className="book-button" onClick={() => handleLinkClick('login')}>Login</button>
          </>
        ) : (
          <button className="book-button" onClick={handleLogout}>Logout</button>
        )}
      </div>
      <button className="menu-toggle" onClick={toggleMenu}>
        ☰
      </button>
    </header>
  );
};

export default Header;

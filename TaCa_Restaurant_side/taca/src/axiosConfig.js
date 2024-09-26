// axiosConfig.js
import axios from 'axios';

console.log('kkkkk')
const axiosInstance = axios.create({
  baseURL: 'http://192.168.246.194:5000/api', // Adjust this to your backend's base URL
  headers: {
    'Content-Type': 'application/json',
  },
});
  
export default axiosInstance;
  
// http://192.168.1.7:5000/api
const axios = require('axios');
const User = require('../models/User');

exports.getBooks = async (req, res) => {
  const q = req.query.q || 'programming';
  const result = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=${q}`);
  res.json(result.data.items);
};

exports.getRecommendations = async (req, res) => {
  const user = await User.findById(req.user.id);
  const genre = req.query.genre || user.favoriteGenres[0] || 'fiction';
  const result = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=subject:${genre}`);
  res.json(result.data.items);
};

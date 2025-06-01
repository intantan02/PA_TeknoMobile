const axios = require('axios');
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Handler untuk mengambil daftar buku
exports.getBooks = async (req, res) => {
  try {
    const q = req.query.q || 'programming';
    const result = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=${q}`);
    res.json(result.data.items);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch books', error: err.message });
  }
};

// Handler untuk rekomendasi buku berdasarkan genre user
exports.getRecommendations = async (req, res) => {
  try {
    // Pastikan req.user ada (middleware JWT harus diterapkan di route ini)
    const user = await User.findById(req.user?.id);
    const genre = req.query.genre || (user && user.favoriteGenres && user.favoriteGenres[0]) || 'fiction';
    const result = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=subject:${genre}`);
    res.json(result.data.items);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch recommendations', error: err.message });
  }
};


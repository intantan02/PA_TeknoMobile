const mongoose = require('mongoose');

const favoriteSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  bookId: {
    type: String, // atau Number, sesuaikan dengan tipe ID buku kamu
    required: true,
  },
  title: String,
  author: String,
  coverUrl: String,
  // Tambahkan field lain jika perlu
}, { timestamps: true });

module.exports = mongoose.model('Favorite', favoriteSchema);
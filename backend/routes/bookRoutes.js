const express = require('express');
const { getBooks, getRecommendations } = require('../controllers/bookController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', getBooks);
router.get('/recommendations', auth, getRecommendations);

module.exports = router;

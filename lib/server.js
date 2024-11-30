const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Mock endpoint to receive data from Flutter app
app.post('/submit', (req, res) => {
  const { bunkName, location, rating, phoneNumber, timestamp } = req.body;

  // Simulate saving data to Google Sheets
  console.log('Received data:', {
    bunkName,
    location,
    rating,
    phoneNumber,
    timestamp,
  });

  // Respond with a success message
  res.status(200).json({ message: 'Data submitted successfully!' });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Mock API server is running on http://localhost:${PORT}`);
});
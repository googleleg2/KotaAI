const dotenv = require("dotenv");

dotenv.config();

async function createPaypalOrder(req, res) {
  res.json({
    success: true,
    message: "PayPal Function Connected",
  });
}

async function capturePaypalOrder(req, res) {
  res.json({
    success: true,
    message: "Capture Function Connected",
  });
}

module.exports = {
  createPaypalOrder,
  capturePaypalOrder,
};
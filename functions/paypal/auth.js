const { onRequest } = require("firebase-functions/v2/https");
const { getAccessToken } = require("./paypal_clients");

exports.paypalAuth = onRequest(async (req, res) => {
  try {
    const token = await getAccessToken();

    res.json({
      success: true,
      accessToken: token,
    });
  } catch (e) {
    console.error(e.response?.data || e);

    res.status(500).json({
      success: false,
      error: "Unable to authenticate with PayPal",
    });
  }
});
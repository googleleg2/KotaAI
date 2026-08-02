const { onRequest } = require("firebase-functions/v2/https");
const axios = require("axios");
const { getAccessToken } = require("./paypal_clients");

exports.createPaypalOrder = onRequest(async (req, res) => {
  try {
    const accessToken = await getAccessToken();

    const order = {
      intent: "CAPTURE",
      purchase_units: [
        {
          amount: {
            currency_code: "USD",
            value: "10.00"
          },
          description: "Kota AI Test Order"
        }
      ],
      application_context: {
        brand_name: "Kota AI",
        landing_page: "LOGIN",
        user_action: "PAY_NOW",
        return_url: "https://example.com/paypal/success",
        cancel_url: "https://example.com/paypal/cancel"
      }
    };

    const response = await axios.post(
      `${process.env.PAYPAL_BASE_URL}/v2/checkout/orders`,
      order,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json"
        }
      }
    );

    const approvalLink = response.data.links.find(
      (link) => link.rel === "approve"
    );

    res.json({
      success: true,
      orderId: response.data.id,
      approvalUrl: approvalLink?.href
    });
  } catch (error) {
    console.error(
      error.response?.data || error.message || error
    );

    res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
});
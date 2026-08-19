const { onRequest } = require("firebase-functions/v2/https");



const axios = require("axios");
const { getAccessToken } = require("./paypal_clients");

exports.createPaypalOrder = onRequest(
  {

    secrets: [
      "PAYPAL_CLIENT_ID",
      "PAYPAL_SECRET",
      "PAYPAL_BASE_URL",
    ],
  },
  async (req, res) => {

    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");

    if (req.method === "OPTIONS") {
      return res.status(204).send("");
    }

    try {
      if (req.method !== "POST") {
        return res.status(405).json({
          success: false,
          error: "Method Not Allowed",
        });
      }

      const {
        orderNumber,
        total,
        currency = "USD",
        items = [],
      } = req.body;

      if (!orderNumber) {
        return res.status(400).json({
          success: false,
          error: "Missing order number.",
        });
      }

      if (!total || total <= 0) {
        return res.status(400).json({
          success: false,
          error: "Invalid order total.",
        });
      }

      const accessToken = await getAccessToken();

      const paypalItems = [
        {
          name: `Kota AI Order #${orderNumber}`,
          quantity: "1",
          unit_amount: {
            currency_code: currency,
            value: Number(total).toFixed(2),
          },
        },
      ];

      const order = {
        intent: "CAPTURE",

        purchase_units: [
          {
            amount: {
              currency_code: currency,
              value: Number(total).toFixed(2),

              breakdown: {
                item_total: {
                  currency_code: currency,
                  value: Number(total).toFixed(2),
                },
              },
            },

            items: paypalItems,

            description: "Kota AI Order",
          },
        ],

        application_context: {
          brand_name: "Kota AI",
          landing_page: "LOGIN",
          user_action: "PAY_NOW",

          return_url:
            `https://kota-discount.web.app/paypal-success?order=${encodeURIComponent(orderNumber)}`,

          cancel_url:
            `https://kota-discount.web.app/paypal-cancel?order=${orderNumber}`,
        },
      };

      const response = await axios.post(
        `${process.env.PAYPAL_BASE_URL}/v2/checkout/orders`,
        order,
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
        }
      );

      const approvalLink = response.data.links.find(
        (link) => link.rel === "approve"
      );

      res.status(200).json({
        success: true,
        orderId: response.data.id,
        status: response.data.status,
        approvalUrl: approvalLink?.href,
      });

    } catch (error) {
      console.error(
        error.response?.data ||
        error.message ||
        error
      );

      res.status(500).json({
        success: false,
        error:
          error.response?.data ||
          error.message,
      });
    }
  }
);
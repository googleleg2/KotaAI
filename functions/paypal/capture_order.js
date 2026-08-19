const { onRequest } = require("firebase-functions/v2/https");
const axios = require("axios");

const { getAccessToken } = require("./paypal_clients");
const { admin, db } = require("../firebase_admin");

exports.capturePaypalOrder = onRequest(
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
        orderId,
        orderNumber,
      } = req.body;

      if (!orderId) {
        return res.status(400).json({
          success: false,
          error: "Missing PayPal Order ID.",
        });
      }

      if (!orderNumber) {
        return res.status(400).json({
          success: false,
          error: "Missing Order Number.",
        });
      }

      const accessToken = await getAccessToken();

      const response = await axios.post(
        `${process.env.PAYPAL_BASE_URL}/v2/checkout/orders/${orderId}/capture`,
        {},
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
        }
      );

      if (response.data.status !== "COMPLETED") {
        return res.status(400).json({
          success: false,
          error: "Payment was not completed.",
        });
      }

      const purchaseUnit =
        response.data.purchase_units[0];

      const capture =
        purchaseUnit.payments.captures[0];

      if (!capture) {
        return res.status(400).json({
          success: false,
          error: "No capture returned from PayPal.",
        });
      }

      if (capture.status !== "COMPLETED") {
        return res.status(400).json({
          success: false,
          error: "Payment capture failed.",
        });
      }

      const orderRef = db
        .collection("orders")
        .doc(orderNumber);

      await orderRef.update({
        paymentStatus: "Paid",
        paymentMethod: "PayPal",

        paypalOrderId: response.data.id,
        paypalCaptureId: capture.id,
        paypalCaptureStatus: capture.status,

        paypalPayerId:
          response.data.payer?.payer_id ?? "",

        paypalEmail:
          response.data.payer?.email_address ?? "",

        amountPaid: Number(
          capture.amount.value
        ),

        currency:
          capture.amount.currency_code,

        deliveryStatus: "Preparing",

        paidAt:
          admin.firestore.FieldValue.serverTimestamp(),
      });

      const updatedOrder =
        await orderRef.get();

      return res.status(200).json({
        success: true,

        orderNumber,

        paymentStatus: "Paid",

        paymentMethod: "PayPal",

        paypalOrderId: response.data.id,

        paypalCaptureId: capture.id,

        captureStatus: capture.status,

        paypalPayerId:
          response.data.payer?.payer_id ?? "",

        paypalEmail:
          response.data.payer?.email_address ?? "",

        amount:
          capture.amount.value,

        currency:
          capture.amount.currency_code,

        order:
          updatedOrder.data(),
      });

    } catch (error) {

      console.error(
        "PayPal Capture Error:",
        error.response?.data ||
        error.message ||
        error
      );

      return res.status(500).json({
        success: false,
        error:
          error.response?.data ||
          error.message ||
          "Unknown PayPal capture error.",
      });
    }
  }
);
// const { onRequest } = require("firebase-functions/v2/https");

// exports.helloWorld = onRequest((req, res) => {
//   res.status(200).json({
//     success: true,
//     message: "Firebase Functions v2 is working!",
//   });
// });

const { paypalAuth } = require("./paypal/auth");
const { createPaypalOrder } = require("./paypal/create_order");

exports.paypalAuth = paypalAuth;
exports.createPaypalOrder = createPaypalOrder;
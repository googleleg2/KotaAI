// const { paypalAuth } =
// require("./paypal/auth");

const {
  createPaypalOrder,
} = require("./paypal/create_order");

const {
  capturePaypalOrder,
} = require("./paypal/capture_order");

// exports.paypalAuth = paypalAuth;

exports.createPaypalOrder = createPaypalOrder;

exports.capturePaypalOrder =
    capturePaypalOrder;


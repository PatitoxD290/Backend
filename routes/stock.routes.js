const express = require("express");
const router = express.Router();
const stockController = require("../controllers/stock.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

router.post("/stock",  verifyToken, stockController.createStock);
router.get("/stock",  verifyToken, stockController.getStocks); 

module.exports = router;

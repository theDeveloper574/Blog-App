
const userRouts = require("express").Router();
const userCon = require("./../controllers/user_controller");
const upload = require("./../config/multer_config");
userRouts.post("/createAccount", upload.single("avatar"), userCon.createAccount);
userRouts.post("/logIn", userCon.logIn);
userRouts.put("/:id", upload.single("avatar"), userCon.updateUser);


module.exports = userRouts;
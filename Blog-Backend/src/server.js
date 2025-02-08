const express = require("express");
const bodyParser = require("body-parser");
const helmet = require("helmet");
const cors = require("cors");
const morgan = require("morgan");
const mongoose = require("mongoose");

const path = require('path');
const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
// Serve the uploads folder
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
mongoose.connect("mongodb+srv://worknf00:rrr1234@cluster0.8tarv.mongodb.net/Blog?retryWrites=true&w=majority&appName=Cluster0");

app.get("/", function (req, res) {
    const messsage = { "message": "Api works MongoDB connect still" };
    res.json(messsage);
});
//create Account
const userRoute = require("./routes/user_route");
app.use("/api/user", userRoute);
const blogRoute = require("./routes/blog_route");
app.use("/api/blog", blogRoute);
const PORT = process.env.PORT || 5001;
app.listen(PORT, function () {
    console.log("Server started: " + PORT);
});
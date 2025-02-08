const { Schema, model } = require("mongoose");
const bcrypt = require("bcrypt");
const uuid = require("uuid");

const userSchema = new Schema({
    id: { type: String, unique: true },
    fullName: { type: String, required: true, },
    email: { type: String, unique: true, required: true },
    password: { type: String, required: true },
    avatar: { type: String, default: "" },
    level: { type: String, default: "Beginner" },
    createdOn: { type: Date },
    updatedOn: { type: Date },
});

userSchema.pre('save', function (next) {
    this.id = uuid.v1();
    this.createdOn = new Date();
    this.updatedOn = new Date();
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(this.password, salt);
    this.password = hash;
    next();
});
userSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function (next) {
    const update = this.getUpdate();
    delete update._id;
    delete update.id;
    this.update = new Date();
    next();
});

const UserModel = model("User", userSchema);
module.exports = UserModel;
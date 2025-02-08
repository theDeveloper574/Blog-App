const UserModel = require("./../models/user_model");
const bcrypt = require('bcrypt');
const UserController = {

    createAccount: async function (req, res) {
        try {
            const userData = req.body;

            if (req.file) {
                userData.avatar = `uploads/${req.file.filename}`;
            }
            const newUser = new UserModel(userData);
            await newUser.save();
            return res.json({
                success: true,
                data: newUser,
                message: "User Created!",
            });
        } catch (ex) {
            if (ex.code === 11000 && ex.keyPattern.email) {
                return res.json({ success: false, message: "This email is already taken." });

            }
            return res.json({
                success: false, message: ex,
            });
        }
    },

    logIn: async function (req, res) {
        try {
            const { email, password } = req.body;
            const foundUser = await UserModel.findOne({ email: email });
            if (!foundUser) {
                return res.json({
                    success: false, message: "User not found!",
                });
            }
            const passMatch = bcrypt.compareSync(password, foundUser.password);
            if (!passMatch) {
                return res.json({ success: false, message: "Enter Correct Password!" });
            }


            return res.json({ success: true, data: foundUser, message: "User Login" });
        } catch (ex) {
            return res.json({ success: false, message: ex, });
        }
    },
    updateUser: async function (req, res) {
        try {
            const userId = req.params.id;
            const updatedReq = { ...req.body };
            // if (req.file) {
            //     userData.avatar = `uploads/${req.file.filename}`;
            //     // userData.avatar = req.file.path;
            // }
            // If a file is uploaded, add avatar to updatedReq
            if (req.file) {
                updatedReq.avatar = `uploads/${req.file.filename}`;
            }
            const updateUser = await UserModel.findOneAndUpdate(
                {
                    _id: userId,
                },
                updatedReq,
                {
                    new: true
                }
            );
            if (!updateUser) {
                return res.json({ success: false, message: "No user found!" });
            }
            return res.json({ success: true, data: updateUser, message: "User Updated!" });

        } catch (ex) {
            return res.json({ success: false, message: ex, });
        }
    }
}




module.exports = UserController;
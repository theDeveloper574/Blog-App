const { Schema, model } = require("mongoose");
// Reply Schema
const replySchema = new Schema({
    user: { type: Schema.Types.ObjectId, ref: "User" },
    replyCon: { type: String, },
    createdOn: { type: Date, }
});

// Blog Schema
const blogSchema = new Schema({
    title: { type: String, required: true },
    content: { type: String, required: true },
    user: { type: Schema.Types.ObjectId, ref: "User", required: true }, // Reference to the user who created the blog
    replies: { type: [replySchema], default: [] },
    createdOn: { type: Date, },
    updatedOn: { type: Date, }
});
blogSchema.pre('save', function (next) {
    this.createdOn = new Date();
    this.updatedOn = new Date();
    next();
});
blogSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function (next) {
    const update = this.getUpdate();
    delete update._id;
    this.updatedOn = new Date();
    next();
});

const BlogModel = model("blogs", blogSchema);

module.exports = BlogModel;
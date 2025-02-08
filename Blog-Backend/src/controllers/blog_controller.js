const BlogModel = require('./../models/blog_model');
const UserModel = require("./../models/user_model");
const BlogController = {

    // Show all blogs
    // getAllBlog: async function (req, res) {
    //     try {
    //         const foundBlogs = await BlogModel.find().populate({ path: "user" }).populate({ path: "replies.user" });
    //         //.populate({ path: "blogs.replies.user" })
    //         if (!foundBlogs) {
    //             return res.json({ success: true, data: [] });
    //         }
    //         return res.json({
    //             success: true, data: foundBlogs
    //         });

    //     } catch (ex) {
    //         res.json({
    //             success: false, message: ex
    //         });
    //     }
    // },
    // Show all blogs with pagination
    getAllBlog: async function (req, res) {
        try {
            // Get page and limit from query parameters, with default values
            const page = parseInt(req.query.page) || 1; // Default page is 1
            const limit = parseInt(req.query.limit) || 6; // Default limit is 10

            // Calculate the skip value
            const skip = (page - 1) * limit;
            // /GET /api/blogs?page=1&limit=10

            // Fetch blogs with pagination
            const foundBlogs = await BlogModel.find()
                .populate({ path: "user" })
                .populate({ path: "replies.user" })
                .sort({ createdOn: -1 })
                .skip(skip) // Skip the first (page-1)*limit documents
                .limit(limit); // Limit the number of results

            // Count the total number of blogs for pagination metadata
            const totalBlogs = await BlogModel.countDocuments();

            if (!foundBlogs || foundBlogs.length === 0) {
                return res.json({ success: true, data: [], total: 0 });
            }

            // Return paginated results
            return res.json({
                success: true,
                data: foundBlogs,
                total: totalBlogs,
                page: page,
                totalPages: Math.ceil(totalBlogs / limit),
            });
        } catch (ex) {
            return res.json({
                success: false,
                message: ex.message || "An error occurred",
            });
        }
    },

    // Get a single blog by user
    getBlog: async function (req, res) {
        try {
            const user = req.params.user;
            const foundBlog = await BlogModel.find({ user: user });

            if (!foundBlog) {
                return res.json({ success: true, data: [] });
            }
            return res.json({ success: true, data: foundBlog, message: "Blog Found!" });

        } catch (ex) {
            return res.json({
                success: false,
                message: ex
            });
        }
    },

    // Create a new blog for a user
    createBlog: async function (req, res) {
        try {
            const { title, content, user } = req.body;

            // Create a new blog document
            const newBlog = new BlogModel({
                title: title,
                content: content,
                user: user,
                createdOn: new Date(),
                updatedOn: new Date(),
            });

            // Save the new blog
            await newBlog.save();
            // Populate the user field with all details
            const populatedBlog = await BlogModel.findById(newBlog._id).populate({
                path: "user",
            });
            return res.json({
                success: true,
                data: populatedBlog,
                message: "Blog created successfully!"
            });
            // return res.json({
            //     success: true,
            //     data: newBlog,
            //     message: "Blog created successfully!"
            // }).populate({ path: "user" });
        } catch (ex) {
            return res.json({
                success: false,
                message: ex.message || ex
            });
        }
    },

    // Remove a blog
    removeBlog: async function (req, res) {
        try {
            const { user, id } = req.body;

            const foundBlog = await BlogModel.findOne({ "_id": id, "user": user });

            if (!foundBlog) {
                return res.json({ success: false, message: "Blog not found!" });
            }

            const blogOwner = foundBlog.user.toString();
            if (blogOwner !== user) {
                return res.json({ success: false, message: "You are not authorized to remove this blog." });
            }
            // Delete the blog from the database
            const deletedBlog = await BlogModel.findByIdAndDelete(id).populate({ path: "user" }).populate({ path: "replies.user", });

            return res.json({
                success: true,
                data: deletedBlog,
                message: "Blog removed"
            });
        } catch (ex) {
            return res.json({
                success: false,
                message: ex.message || ex
            });
        }
    },

    // Update a blog
    updateBlog: async function (req, res) {
        try {
            const { user, title, content, id } = req.body;
            const updateFields = {};

            if (title) {
                updateFields["title"] = title;
            }
            if (content) {
                updateFields["content"] = content;
            }

            const updatedBlog = await BlogModel.findOneAndUpdate(
                { user: user, "_id": id },
                { $set: updateFields },
                { new: true }
            ).populate({ path: 'user' }).populate({ path: "replies.user" });

            if (!updatedBlog) {
                return res.json({ success: false, message: "Blog not found" });
            }

            return res.json({
                success: true,
                data: updatedBlog,
                message: "Blog updated successfully"
            });
        } catch (ex) {
            return res.json({
                success: false,
                message: ex.message || "Error updating blog"
            });
        }
    },

    // Add to favorite blog
    addFav: async function (req, res) {
        try {
            const { user, blogId } = req.body;
            const updatedBlog = await BlogModel.findOneAndUpdate(
                { user: user, "blogs._id": blogId },
                { $set: { "blogs.$.isFav": true } },
                { new: true },
            );
            if (!updatedBlog) {
                return res.json({ success: false, message: "did not find blog" });
            }
            return res.json({ success: true, data: updatedBlog, message: "Blog added to favourite" });
        } catch (ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Remove from favorite
    removeFav: async function (req, res) {
        try {
            const { user, blogId } = req.body;
            const updatedBlog = await BlogModel.findOneAndUpdate(
                { user: user, "blogs._id": blogId },
                { $set: { "blogs.$.isFav": false } },
                { new: true }
            );
            if (!updatedBlog) {
                return res.json({ success: false, message: "did not find blog" });
            }
            return res.json({ success: true, data: updatedBlog, message: "Blog removed from favourite" });
        } catch (ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Add a reply to a blog
    addReply: async function (req, res) {
        try {
            const userId = req.params.id;
            const findUser = await UserModel.findById(userId);
            const { content, blogId } = req.body;

            const foundBlog = await BlogModel.findOne({ "_id": blogId });
            if (!foundBlog) {
                return res.json({ success: false, message: "Blog not found!" });
            }

            const newReply = await BlogModel.findOneAndUpdate(
                { "_id": blogId },
                { $push: { "replies": { user: findUser, replyCon: content, createdOn: new Date() } } },
                { new: true, }
            ).populate({ path: "user" }).populate({ path: "replies.user" });
            return res.json({
                success: true, data: newReply, message: "New reply added!"
            });
        } catch (ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Delete a reply from a blog
    deleteReply: async function (req, res) {
        try {
            const { user, blogId, replyId } = req.body;

            const foundBlog = await BlogModel.findOneAndUpdate(
                {
                    "_id": blogId,
                    "replies._id": replyId,
                    "replies.user": user
                },
                {
                    $pull: { "replies": { _id: replyId } }
                },
                { new: true }
            );

            if (!foundBlog) {
                return res.json({ success: false, message: "Reply not found or user is not authorized to delete this reply." });
            }

            return res.json({ success: true, data: foundBlog, message: "Reply removed successfully." });
        } catch (ex) {
            res.json({ success: false, message: ex.message || ex });
        }
    }
};

module.exports = BlogController;

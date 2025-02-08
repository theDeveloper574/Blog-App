const blogRouter = require("express").Router();
const blogCon = require("./../controllers/blog_controller");

blogRouter.get("/:user", blogCon.getBlog);

blogRouter.get("/", blogCon.getAllBlog);
blogRouter.post("/:id", blogCon.addReply);
blogRouter.post("/", blogCon.createBlog);
blogRouter.delete("/deleteReply", blogCon.deleteReply);

blogRouter.post("/addFav", blogCon.addFav);

blogRouter.post("/removeFav", blogCon.removeFav);

blogRouter.delete("/", blogCon.removeBlog);

blogRouter.put("/", blogCon.updateBlog);

module.exports = blogRouter;
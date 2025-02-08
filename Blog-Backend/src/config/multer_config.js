const multer = require('multer');
const path = require('path');

// Configure storage for uploaded files
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Upload directory
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

// File filter to limit uploads to images
// const fileFilter = (req, file, cb) => {
//     const allowedMimeTypes = ['image/png', 'image/jpg', 'image/jpeg'];

//     if (allowedMimeTypes.includes(file.mimetype)) {
//         cb(null, true);
//     } else {
//         cb(new Error('Only PNG, JPG, and JPEG image files are allowed!'), false);
//     }
// };

const upload = multer({
    storage: storage,
    // fileFilter: fileFilter,
    limits: { fileSize: 1000000 } // 1MB size limit
});

module.exports = upload;

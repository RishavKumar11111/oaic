const router = require('express').Router();
module.exports = router;
const vendorController = require('../controller/vendor.controller');
const multer = require('multer');
const path = require('path');

const logBal = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');

/**
 * @swagger
 * /vendor/getDealerDists:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get approved districtwise P.O.(Purchase Order) list which is to be delivered by vendor.
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getDealerDists', vendorController.getDealerDists);

/**
 * @swagger
 * /vendor/getAllDistIndent:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get all P.O.(Purchase Order) list against approved P.O.(Purchase Order) by D.M.
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getAllDistIndent', vendorController.getAllDistIndent);

/**
 * @swagger
 * /vendor/getIndentOrdersForDeliver:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get P.O.(Purchase Order) number that are approved by D.M. and is to be delivered by vendor. 
 *    parameters:
 *      -   in: query
 *          name: PONo
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getIndentOrdersForDeliver', vendorController.getIndentOrdersForDeliver);

/**
 * @swagger
 * /vendor/getDMDetails:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get all DM details that is to be shown in reveiver's bill after order is delivered.
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getDMDetails', (req, res) => {
    vendorController.getDMDetails(req.query.dist_id, (result) => {
        res.send(result);
    });
});


/**
 * @swagger
 * /vendor/checkInvoiceNoIsExist:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Check if the invoice number of delivered order match the ordered invoice number of the product.
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/checkInvoiceNoIsExist', async (req, res) => {
    let result = await vendorController.checkInvoiceNoIsExist(req.query.invoice_no);
    res.send(result);
});
let invoiceStorage = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, './public/uploads');
    },
    filename: function (req, file, callback) {
        callback(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
});
let fileFilter = (req, file, callback) => {
    if (file.mimetype == 'application/pdf') {
        callback(null, true);
    } else {
        callback(new Error('File Format Should be PDF'));
    }
}
var upload = multer({ storage: invoiceStorage, fileFilter: fileFilter }).fields([
    { name: 'invoice', maxCount: 1 }
]);



/**
 * @swagger
 * /vendor/addInvoice:
 *  post:
 *    tags: ['Vendor Module']
 *    description:  Add vendor invoice details and upload the softcopy of vendor invoice.
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.post('/addInvoice', (req, res) => {
    upload(req, res, async err => {
        if (err) throw err;
        let body = JSON.parse(req.body.Name1);
        let allfiles = req.files;
        body.invoice.InvoicePath = allfiles.invoice[0].path.replace('public', '');

        try {
            let invoice_no = await vendorController.addInvoice(body.invoice, body.items_for_deliver, req.payload.VendorID);
            res.send(invoice_no);
            logBal.addAuditLog(req.payload.user_id, "Generate invoice.", "success", 'Invoice generated successfully.', req.originalUrl.split("?").shift(), '/dealer', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Generate invoice.", "failure", 'Failed to generate invoice.', req.originalUrl.split("?").shift(), '/dealer', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
    });
});
// Generated Invoices


/**
 * @swagger
 * /vendor/getAllInvoices:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get all generated invoice details for the corresponding financial year of delivered order.
 *    parameters:
 *      -   in: query
 *          name: fin_year
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getAllInvoices', vendorController.getAllInvoices);


// router.get('/getInvoiceDetailsByInvoiceNo', vendorController.getInvoiceDetailsByInvoiceNo);

/**
 * @swagger
 * /vendor/getFinYearWisePendingApprovalList:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Get all pending invoice details for the corresponding financial year.
 *    parameters:
 *      -   in: query
 *          name: fin_year
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getFinYearWisePendingApprovalList', vendorController.getFinYearWisePendingApprovalList);

/**
 * @swagger
 * /vendor/getInvoiceDetailsByInvoiceNo:
 *  get:
 *    tags: ['Vendor Module']
 *    description:  Show the P.O.(Purchase Order) Details of the generated invoice list by invoice number
 *    parameters:
 *      -   in: query
 *          name: invoice_no
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getInvoiceDetailsByInvoiceNo', vendorController.getInvoiceDetailsByInvoiceNo);

/**
 * @swagger
 * /vendor/updateApprovalToPayble:
 *  post:
 *    tags: ['Vendor Module']
 *    description:  Updated list of the pending payments of the purchase order
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.post('/updateApprovalToPayble', async (req, res) => {
    try {
        let result = await vendorController.updateApprovalToPayble(req.body.approval_id, req.body.dl_remark);
        res.send(result);
        logBal.addAuditLog(req.payload.user_id, "Resolve withheld amount of pay to dealer.", "success", 'Successfully resolved the withheld amount of pay to dealer.', req.originalUrl.split("?").shift(), '/dealer', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logBal.addAuditLog(req.payload.user_id, "Resolve withheld amount of pay to dealer.", "failure", 'Failed to resolve the withheld amount.', req.originalUrl.split("?").shift(), '/dealer', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
const router = require('express').Router();
const logController = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
var bankController = require('../controller/bank.controller');
const validation = require('../validation/bank/bank.validation');
const createError = require('http-errors');
module.exports = router;

const c_year = new Date().getFullYear().toString();
const c_month = new Date().getMonth();
const c_fin_year = c_month >= 3 ? c_year + "-" + (parseInt(c_year.slice(2, 4)) + 1).toString() : (parseInt(c_year) - 1).toString() + "-" + c_year.slice(2, 4);











/**
 * @swagger
 * /bank/getAllPaymentApprovals:
 *  get:
 *    tags: ['Bank Module']
 *    description: Get all Approval list, those Approvals are pending at bank to confirm Vendor Payment 
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
router.get('/getAllPaymentApprovals', validation.getAllPaymentApprovals, bankController.getAllPaymentApprovals);

/**
 * @swagger
 * /bank/getApprovalDetails:
 *  get:
 *    tags: ['Bank Module']
 *    description: Get all Approval details by Approval-ID 
 *    parameters:
 *       - in: query
 *         name: approval_id
 *         schema:
 *           type: string
 *         required: true
 *         description: Approval ID.
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
router.get('/getApprovalDetails', validation.getApprovalDetails, bankController.getApprovalDetails);


/**
 * @swagger
 * /bank/confirmPayments:
 *  post:
 *    tags: ['Bank Module']
 *    description: Confirm pending payemnts 
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
router.post('/confirmPayments', async(req, res) => {
    try {
        let result = await bankController.confirmPayments(req.body.approval_list);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Approve dealer payments by bank.", "success", 'Successfulyy pay to dealer by bank.', req.originalUrl.split("?").shift(), '/bank', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Approve dealer payments by bank.", "failure", 'Failed to approve dealer payments.', req.originalUrl.split("?").shift(), '/bank', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});


/**
 * @swagger
 * /bank/getApprovedPayments:
 *  get:
 *    tags: ['Bank Module']
 *    description: Get Approvals List, thsose are successfully approved by Bank officer 
 *    parameters:
 *      -   in: query
 *          name: fin_year
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.get('/getApprovedPayments', validation.getApprovedPayments, bankController.getApprovedPayments);


const express = require('express');
const router = express.Router();
const dmController = require('../controller/dm.controller')
const validation = require('../validation/dm/dm.validation')
module.exports = router;


/**
 * @swagger
 * /dm/getAllPaymentApprovals:
 *  get:
 *    tags: ['DM Module']
 *    description: Get all pending Vendor Payment Approval list 
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
router.get('/getAllPaymentApprovals', validation.getAllPaymentApprovals, dmController.getAllPaymentApprovals);

/**
 * @swagger
 * /dm/getApprovalDetails:
 *  get:
 *    tags: ['DM Module']
 *    description: Get Vendor Approval details by Approval-ID 
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
router.get('/getApprovalDetails', dmController.getApprovalDetails);

/**
 * @swagger
 * /dm/forwardToBank:
 *  post:
 *    tags: ['DM Module']
 *    description: Forward / Approve the pending Payment Approvals to Bank
 *    parameters:
 *       - in: body
 *         name: approval_ids
 *         schema:
 *           type: string
 *         required: true
 *         description: Approval IDs.
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
router.post('/forwardToBank', dmController.forwardToBank);

/**
 * @swagger
 * /dm/getApprovedPayments:
 *  get:
 *    tags: ['DM Module']
 *    description: Get all Vendor Payment Approvals list those are Forwarded to Bank for check the status. 
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
router.get('/getApprovedPayments', dmController.getApprovedPayments);

/**
 * @swagger
 * /dm/getPendinglistOfGenerateIndent:
 *  get:
 *    tags: ['DM Module']
 *    description:  Get pending P.O.(Purchase Order) list those are Initiated by Accountant to Generate / Approve
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
router.get('/getPendinglistOfGenerateIndent', dmController.getPendinglistOfGenerateIndent);

/**
 * @swagger
 * /dm/getPendinglistOfCancelIndent:
 *  get:
 *    tags: ['DM Module']
 *    description: Get pending P.O.(Purchase Order) list those are requested  by Accountant for Cancellation.
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
router.get('/getPendinglistOfCancelIndent', dmController.getPendinglistOfCancelIndent);

/**
 * @swagger
 * /dm/generateIndents:
 *  post:
 *    tags: ['DM Module']
 *    description: Approve P.O. / Generate Purchase Order
 *    parameters:
 *      -   in: body
 *          name: PONoList
 *          schema:
 *              type: string
 *          required: true
 *          description: P.O. (Purchase Order) Number List.
 *      -   in: body
 *          name: PermitNoList
 *          schema:
 *              type: string
 *          required: true
 *          description: P.O. (Purchase Order) Number List.
 * 
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
router.post('/generateIndents', dmController.GenerateIndent);

/**
 * @swagger
 * /dm/cancelIndents:
 *  post:
 *    tags: ['DM Module']
 *    description: Approve Cancellation of P.O.(Purchase Order) as per request of Accountant
 *    parameters:
 *      -   in: body
 *          name: PONoList
 *          schema:
 *              type: string
 *          required: true
 *          description: P.O. (Purchase Order) Number List.
 *      -   in: body
 *          name: PermitNoList
 *          schema:
 *              type: string
 *          required: true
 *          description: P.O. (Purchase Order) Number List. 
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
router.post('/cancelIndents', dmController.CancelIndent);
const router = require('express').Router();
const permission = require('../permissions/permission');
const reportController = require('../controller/report.controller');
module.exports = router;

/**
 * @swagger
 * /report/getApprovalDetails:
 *  get:
 *    tags: ['Report Module']
 *    description: Get Approval details by Approval-ID 
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
router.get('/getApprovalDetails', permission.multipleRolePermission(['DM', 'ACCOUNTANT', "ADMIN", "BANK", "ACC-HEAD"]), reportController.getApprovalDetails)

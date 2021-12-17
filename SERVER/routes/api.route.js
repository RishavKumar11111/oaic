const router = require('express').Router();
const permission = require('../permissions/permission');
const apiController = require('../controller/api.controller');

module.exports = router;


router.get('/getFinYear', function (req, res) {
  var year = new Date().getFullYear().toString();
  var month = new Date().getMonth();
  var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
  let Years = [];
  Years.push(finYear);
  for (let i = 1; i < 1; i++) {
    Years.push((parseInt(finYear.slice(0, 4)) - i) + '-' + (parseInt(finYear.slice(5, 7)) - i));
  }
  res.send(Years);
});

/**
 * @swagger
 * /api/getPODetails:
 *  get:
 *    tags: ['API Module']
 *    description: Get P.O.(Purchase Order) Details  
 *    parameters:
 *       - in: query
 *         name: PONumber
 *         schema:
 *           type: string
 *         required: true
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
router.get('/getPODetails', permission.multipleRolePermission(['DM', 'ACCOUNTANT', 'DEALER']), apiController.getPODetails);

/**
 * @swagger
 * /api/UserLoginDetails:
 *  get:
 *    tags: ['API Module']
 *    description: Show all login details that includes user roles, user Name, user ID, district ID, current date.
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
router.get('/UserLoginDetails', permission.multipleRolePermission(['DM', 'ACCOUNTANT', 'DEALER', "ADMIN", "BANK", "ACC-HEAD"]), apiController.UserLoginDetails)

/**
 * @swagger
 * /api/checkUserPemission/:Role:
 *  get:
 *    tags: ['API Module']
 *    description: If the user login is valid then, allow user to login else give an "Invalid User" error.
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
router.get('/checkUserPemission/:Role', apiController.checkUserPemission);


/**
 * @swagger
 * /api/getPackagesList:
 *  post:
 *    tags: ['API Module']
 *    description: Show all entered item and package details by admin.
 *    parameters:
 *       - in: body
 *         name: DivisionID
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Implement
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Make
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Model
 *         schema:
 *           type: string
 *         required: true
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
router.post('/getPackagesList', permission.multipleRolePermission(['ADMIN']), apiController.getPackagesList);

/**
 * @swagger
 * /api/getPackageSizeList:
 *  get:
 *    tags: ['API Module']
 *    description: Show all entered item and package details by admin and accountant.
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
router.get('/getPackageSizeList', permission.multipleRolePermission(['ADMIN', 'ACCOUNTANT']), apiController.getPackageSizeList);

/**
 * @swagger
 * /api/getPackagePrice:
 *  post:
 *    tags: ['API Module']
 *    description: Get the package unit of measurement as per the package size in invoice and PO module. 
 *    parameters:
 *       - in: body
 *         name: DivisionID
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Implement
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Make
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: Model
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: PackageSize
 *         schema:
 *           type: string
 *         required: true
 *       - in: body
 *         name: UnitOfMeasurement
 *         schema:
 *           type: string
 *         required: true
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
router.post('/getPackagePrice', permission.multipleRolePermission(['ACCOUNTANT']), apiController.getPackagePrice);

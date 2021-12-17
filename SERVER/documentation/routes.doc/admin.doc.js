/**
 * @swagger
 * /admin/getAllDistricts:
 *  get:
 *    tags: ['Admin Module']
 *    description: Get Approvals List, thsose are successfully approved by Bank officer 
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
exports.getAllDistricts = (req, res, next) => next();


/**
 * @swagger
 * /admin/getDMList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Show all District Managers List to admin.
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
exports.getDMList = (req, res, next) => next();

/**
 * @swagger
 * /admin/modifyDMDetail:
 *  post:
 *    tags: ['Admin Module']
 *    description: Modify selected District Manager's details. 
 *    parameters:
 *      -   in: body
 *          name: u_data
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: dm_id 
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: DistrictID
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
exports.modifyDMDetail = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAccList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Show all Accountants List to admin.
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
exports.getAccList = (req, res, next) => next();

/**
 * @swagger
 * /admin/modifyAccDetail:
 *  post:
 *    tags: ['Admin Module']
 *    description: Modify selected District Manager's details. 
 *    parameters:
 *      -   in: body
 *          name: u_data
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: dm_id 
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: DistrictID
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
exports.modifyAccDetail = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAllDlList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all available registered vendor's list. 
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
exports.getAllDlList = (req, res, next) => next();

/**
 * @swagger
 * /admin/getDistWiseDealerList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all dealer's details by district in registered vendor's list. 
 *    parameters:
 *      -   in: query
 *          name: dist_id
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
exports.getDistWiseDealerList = (req, res, next) => next();

/**
 * @swagger
 * /admin/getDlAllDetailByDlId:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all dealer's details by dlId from view button of all registered vendor's list. 
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
exports.getDlAllDetailByDlId = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAllItemList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Load all entered items list so that admin can take action(view/add/remove) against it.
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
exports.getAllItemList = (req, res, next) => next();

/**
 * @swagger
 * /admin/getDivisionList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Load all available divisions in the entry of item details. 
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
exports.getDivisionList = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateItemDetail:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin modifies the selected item details from the available items list. 
 *    parameters:
 *      -   in: body
 *          name: originalItem
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: updateData 
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
exports.updateItemDetail = (req, res, next) => next();

/**
 * @swagger
 * /admin/removeItem:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin removes items from the available items list. 
 *    parameters:
 *      -   in: body
 *          name: Make
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: Model 
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: Implement
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
exports.removeItem = (req, res, next) => next();

/**
 * @swagger
 * /admin/addItem:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin adds the item details. 
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
exports.addItem = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateDealerDetail:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin modifies the selected dealer's/vendor's details. 
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
exports.updateDealerDetail = (req, res, next) => next();

/**
 * @swagger
 * /admin/removeDealer:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin removes dealer/vendor from registered dealer's/vendor's list. 
 *    parameters:
 *      -   in: body
 *          name: VendorID
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
exports.removeDealer = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAllImplementsForAddItem:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all available Implements for adding an item in the item details form. 
 *    parameters:
 *      -   in: query
 *          name: DivisionID
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
exports.getAllImplementsForAddItem = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAvlMakesForAddItem:
 *  post:
 *    tags: ['Admin Module']
 *    description: Fetch all available makes for adding an item in the item details form. 
 *    parameters:
 *      -   in: body
 *          name: DivisionID
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: Implement 
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
exports.getAvlMakesForAddItem = (req, res, next) => next();

/**
 * @swagger
 * /admin/addCustomerDetails:
 *  post:
 *    tags: ['Admin Module']
 *    description: After the add-customer detais entry form is final, admin finally submits the customers details into DB . 
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
exports.addCustomerDetails = (req, res, next) => next();

/**
 * @swagger
 * /admin/getCustomerList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Get all registered customers list to admin. 
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
exports.getCustomerList = (req, res, next) => next();

/**
 * @swagger
 * /admin/removeCustomer:
 *  post:
 *    tags: ['Admin Module']
 *    description: Admin removes customer from registered customer's list. 
 *    parameters:
 *      -   in: body
 *          name: CustomerID
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
exports.removeCustomer = (req, res, next) => next();

// // ===================================== RECEIVE PAYMENT PART START =====================================


/**
 * @swagger
 * /admin/getAllSource:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all available sources after admin selects the payment receive details. 
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
exports.getAllSource = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAllSchema:
 *  get:
 *    tags: ['Admin Module']
 *    description: Fetch all available schemes after admin selects the payment receive details. 
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
exports.getAllSchema = (req, res, next) => next();

/**
 * @swagger
 * /admin/getComponentsOfSchema:
 *  get:
 *    tags: ['Admin Module']
 *    description: Get all components of selected scheme to admin in the payment received detail form. 
 *    parameters:
 *      -   in: query
 *          name: schemaId
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
exports.getComponentsOfSchema = (req, res, next) => next();

/**
 * @swagger
 * /admin/addReceivedPayment:
 *  post:
 *    tags: ['Admin Module']
 *    description: Add received payment details after the admin accepts/receives it. 
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
exports.addReceivedPayment = (req, res, next) => next();

/**
 * @swagger
 * /admin/getDateWiseAuditLogData:
 *  post:
 *    tags: ['Admin Module']
 *    description: Get all audit log data by datewise to admin. 
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
exports.getDateWiseAuditLogData = (req, res, next) => next();

/**
 * @swagger
 * /admin/getAllAppliedDealerList:
 *  get:
 *    tags: ['Admin Module']
 *    description: Get all applied dealers list for approval/rejection by admin. 
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
exports.getAllAppliedDealerList = (req, res, next) => next();

/**
 * @swagger
 * /admin/approvDealers:
 *  post:
 *    tags: ['Admin Module']
 *    description: Approve the dealers by the admin from the applied vendors list
 *    parameters:
 *      -   in: body
 *          name: 
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
exports.approvDealers = (req, res, next) => next();

/**
 * @swagger
 * /admin/rejectDealers:
 *  post:
 *    tags: ['Admin Module']
 *    description: Reject the dealers by the admin from the applied vendors list. 
 *    parameters:
 *      -   in: body
 *          name: 
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
exports.rejectDealers = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateVendorBasicDetails:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update Vendor Basic details by admin. 
 *    parameters:
 *      -   in: body
 *          name: Name1
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
exports.updateVendorBasicDetails = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateVendorServices:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update vendor services by admin. 
 *    parameters:
 *      -   in: query
 *          name: VendorID
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
exports.updateVendorServices = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateVendorContactPersonDetails:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update Vendor Contact person details by the admin. 
 *    parameters:
 *      -   in: query
 *          name: VendorID
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
exports.updateVendorContactPersonDetails = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateVendorPrincipalPlaces:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update vendor's principal of place by the admin. 
 *    parameters:
 *      -   in: query
 *          name: VendorID
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
exports.updateVendorPrincipalPlaces = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateVendorBankDetails:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update the vendor bank details by the admin. 
 *    parameters:
 *      -   in: body
 *          name: originalItem
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: updateData 
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
exports.updateVendorBankDetails = (req, res, next) => next();

/**
 * @swagger
 * /admin/getCustomerDetails:
 *  get:
 *    tags: ['Admin Module']
 *    description: Get all registered customers details on final submission of customer details form by the customer. 
 *    parameters:
 *      -   in: body
 *          name: CustomerID
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
exports.getCustomerDetails = (req, res, next) => next();

/**
 * @swagger
 * /admin/updateCustomerDetails/:CustomerID:
 *  post:
 *    tags: ['Admin Module']
 *    description: Update the customer details form by the admin. 
 *    parameters:
 *      -   in: body
 *          name: u_data
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: dm_id 
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: DistrictID
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
exports.updateCustomerDetails = (req, res, next) => next();


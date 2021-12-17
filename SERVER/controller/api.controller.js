const { db } = require('../config/config');
const createError = require('http-errors');


exports.getPODetails = async (req, res, next) => {
    try {
        const response = await db.POMasterModel.findAll({
            raw: true,
            where: {
                PONo: req.query.PONumber
            }
        });
        const POType = response[0].POType;
        let customerDetails = {};
        if(POType == 'Subsidy') {
            customerDetails = await db.OrderMasterModel.findOne({
                raw: true,
                where: { permit_no: response[0].OrderReferenceNo }
            })
        } else if(response[0].CustomerID) {
            const result = await db.CustomerMaster.findOne({
                raw: true,
                where: { CustomerID: response[0].CustomerID }
            })
            customerDetails.CustomerName = result.LegalCustomerName;
            customerDetails.OrderReferenceNo = response[0].CustomerOrderRefence;
            customerDetails.CustomerMobileNumber = result.ContactNumber;
            customerDetails.CustomerEmailID = result.EmailID;
            customerDetails.CustomerGSTN = result.GSTN;
        }

        const DMDetails = await db.DMMaster.findOne({
            raw: true,
            where: {
                dist_id:  response[0].DistrictID
            }
        });
        const accountantDetails = await db.AccountantMaster.findOne({
            raw: true,
            where: {
                dist_id:  response[0].DistrictID
            }
        });
        const vendorDetails = await db.VendorMaster.findOne({
            raw: true,
            where: {
                VendorID: response[0].VendorID
            }
        });

        const VendorData = await db.VendorPrincipalPlace.findOne({
            raw: true,
            where: {
                VendorID: response[0].VendorID
            }
        });
        vendorDetails.Address = VendorData.Address;
    

        return res.send({ 
            DMDetails: DMDetails,
            vendorDetails: vendorDetails,
            orderList: response,
            customerDetails: customerDetails,
            purchasOrderType: POType,
            accountantDetails: accountantDetails
        });
    } catch (e) {
        console.error(e);
        return next(createError.InternalServerError());
    }
}
exports.UserLoginDetails = (req, res, next) => {
        res.send({ CSRFToken: "req.csrfToken()", UserRole: req.payload.role, UserName: req.payload.UserName, UserID: req.payload.user_id, DistrictID: req.payload.DistrictID, currentDate: new Date() });
}
exports.checkUserPemission = (req, res, next) => {
        if(req.params.Role == req.payload.role) {
            return res.send(true);
        } else {
            return res.status(403).send(false);
        }
}




exports.getPackagesList = async (req, res, next) => {
    try {
        const response = await db.ItemPackageMasterModel.findAll({
            raw: true,
            order: [['PackageSize', 'ASC']],
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make,
                Model: req.body.Model
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        return next(createError.InternalServerError());
    }
}
exports.getPackageSizeList = async (req, res, next) => {
    try {
        const response = await db.sequelize.query(`SELECT * FROM "ItemPackageSizeMaster" ORDER BY CAST("PackageSize" AS INT)`);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        return next(createError.InternalServerError());
    }
}
exports.getPackagePrice = async (req, res, next) => {
    try {
        const response = await db.ItemPackageMasterModel.findOne({
            raw: true,
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make,
                Model: req.body.Model,
                PackageSize: req.body.PackageSize,
                UnitOfMeasurement: req.body.UnitOfMeasurement
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        return next(createError.InternalServerError());
    }
}
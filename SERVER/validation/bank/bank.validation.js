const schema = require('./bank.schema');
const createError = require('http-errors');

module.exports = {
    getAllPaymentApprovals: async (req, res, next) => {
        try{
            const valueQuery = schema.onlyFincancialYear.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getApprovalDetails: async(req, res, next) => {
        try{
            const valueQuery = schema.getApprovalDetails.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    confirmPayments: async(req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            const valueBody = schema.confirmPaymentsBody.validate(req.body);
            if (valueQuery.error) throw valueQuery.error;
            if (valueBody.error) throw valueBody.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getApprovedPayments: async (req, res, next) => {
        try{
            const valueQuery = schema.onlyFincancialYear.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    }
}
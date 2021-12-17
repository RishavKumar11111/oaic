const schema = require('./public.schema');
const createError = require('http-errors');


module.exports = {
    getStateList: async (req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getDistrictList: async (req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    updatePMDetails: async(req, res, next) => {
        try{
            const valueParams = schema.updatePMDetailsParams.validate(req.params);
            const valueQuery = schema.blankData.validate(req.query);
            const valueBody = schema.updatePMDetailsBody.validate(req.body);
            if (valueParams.error) throw valueParams.error;
            if (valueQuery.error) throw valueQuery.error;
            if (valueBody.error) throw valueBody.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getTargetListOfAllItda: async (req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    setItdaTarget: async(req, res, next) => {
        try{
            const valueParams = schema.setItdaTargetParams.validate(req.params);
            const valueQuery = schema.blankData.validate(req.query);
            const valueBody = schema.setItdaTargetBody.validate(req.body);
            if (valueParams.error) throw valueParams.error;
            if (valueQuery.error) throw valueQuery.error;
            if (valueBody.error) throw valueBody.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getAllFarmersDetails: async(req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getAllSubsidyDetails: async(req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
    getAllTargetDetails: async(req, res, next) => {
        try{
            const valueQuery = schema.blankData.validate(req.query);
            if (valueQuery.error) throw valueQuery.error;
            next();
        } catch(e) {
            next(createError.BadRequest(e.message));
        }
    },
}
const { Joi } = require('express-validation')

module.exports = {
    blankData: Joi.object({}),


    updatePMDetailsParams: Joi.object({
        PMCode: Joi.string().max(2).required()
    }),
    updatePMDetailsBody: Joi.object({
        PMName: Joi.string(),
        PMMobileNo: Joi.string().min(10).max(10)
    }),

    setItdaTargetParams: Joi.object({
        itdaCode: Joi.string().max(2).required()
    }),
    setItdaTargetBody: Joi.object({
        Target: Joi.number().required()
    }),
}
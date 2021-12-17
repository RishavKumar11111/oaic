const Joi = require('joi')

module.exports = {
    blankData: Joi.object({}),
    onlyFincancialYear: Joi.object({
        fin_year: Joi.string().required()
    }),


    // getApprovalDetails: Joi.object({
    //     approval_id: Joi.string().required()
    // }),


    // confirmPaymentsBody: Joi.object({
    //     approval_list: Joi.array().items({
            
    //     })
    // })


}
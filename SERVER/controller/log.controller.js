const LogModel = require('../models/Log.model');

function getCurrentFinYear() {
    return new Promise(resolve => {
        var year = new Date().getFullYear().toString();
        var month = new Date().getMonth();
        var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        resolve(finYear);
    })
}

exports.addAuditLog = async (userId, action, status, remark, refUrl, route, ip, bName, bVersion) => {
    try {
        let finYear = await getCurrentFinYear();
        const data = {
            date_time: new Date(), 
            fin_year: finYear, 
            user_id: userId, 
            action: action, 
            status: status, 
            remark: remark, 
            ref_url: refUrl, 
            route: route, 
            ip: ip, 
            browser_name: bName, 
            browser_version: bVersion
        }
        await LogModel.create(data);      
    } catch (e) { 
        console.error(e);
    }
}

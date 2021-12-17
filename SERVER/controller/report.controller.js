const { db } = require('../config/config');
const createError = require('http-errors');

exports.getApprovalDetails = async (req, res, next) => {
    try {
        const approval_id = req.query.approval_id;
        let queryText1 = `select e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
        from approval a
        left join approval_desc d on d.approval_id = a.approval_id
        left join orders e on e.permit_no = d.permit_no
        left join "ItemMaster" f on f.implement = e.implement and f.make = e.make and f.model = e.model
        left join mrr_desc g on g.permit_no = d.permit_no
        where a.approval_id = '${approval_id}'
        group by e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
        let response1 = db.sequelize.query(queryText1);

        let queryText2 = `select a.invoice_no, a.indent_no, indt.indent_date, b.invoice_date, indt.indent_ammount, b.invoice_ammount from approval a
        inner join indent indt on indt.indent_no = a.indent_no
        inner join invoice b on b.invoice_no = a.invoice_no
        where a.approval_id = '${approval_id}'`;
        let response2 = db.sequelize.query(queryText2);

        let queryText3 = `select c.* from approval a
        inner join "VendorMaster" c on c."VendorID" = a.dl_id
        where a.approval_id = '${approval_id}'`;
        let response3 = await db.sequelize.query(queryText3);

        let response11 = await response1;
        let response22 = await response2;
        res.send({ invoice: response22[0][0], dl: response3[0][0], data: response11[0] });
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}